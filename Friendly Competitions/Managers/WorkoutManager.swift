import Algorithms
import Combine
import ECKit
import ECKit_Firebase
import Factory
import Firebase
import FirebaseFirestore
import HealthKit
import UIKit

// sourcery: AutoMockable
protocol WorkoutManaging {
    func update() -> AnyPublisher<Void, Error>
}

final class WorkoutManager: WorkoutManaging {
    
    // MARK: - Private Properties
    
    @Injected(Container.competitionsManager) private var competitionsManager
    @Injected(Container.healthKitManager) private var healthKitManager
    @Injected(Container.userManager) private var userManager
    @Injected(Container.database) private var database
    
    private let query = PassthroughSubject<Void, Never>()
    private let uploadFinished = PassthroughSubject<Void, Error>()
    private var cancellables = Cancellables()
    
    // MARK: - Lifecycle
    
    init() {
        Publishers
            .Merge3(
                healthKitManager.backgroundDeliveryReceived,
                query,
                UIApplication.willEnterForegroundNotification.publisher
            )
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMapLatest(requestWorkouts)
            .combineLatest(userManager.userPublisher)
            .sinkAsync { [weak self] workouts, user in
                guard let strongSelf = self else { return }
                defer { strongSelf.uploadFinished.send() }
                let batch = strongSelf.database.batch()
                try workouts.forEach { workout in
                    let document = strongSelf.database.document("users/\(user.id)/workouts/\(workout.id)")
                    _ = try batch.setDataEncodable(workout, forDocument: document)
                }
                try await batch.commit()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    func update() -> AnyPublisher<Void, Error> {
        uploadFinished
            .handleEvents(receiveSubscription: { [weak self] _ in self?.query.send() })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods

    private func requestWorkouts() -> AnyPublisher<[Workout], Never> {
        competitionsManager.competitions
            .map { competitions -> ([WorkoutType: [WorkoutMetric]], DateInterval) in
                let workoutTypes = competitions
                    .reduce(into: [WorkoutType: [WorkoutMetric]]()) { partialResult, competition in
                        guard case let .workout(workoutType, metrics) = competition.scoringModel else { return }
                        let metricsForWorkoutType = (partialResult[workoutType] ?? [])
                            .appending(contentsOf: metrics)
                            .uniqued()
                        partialResult[workoutType] = Array(metricsForWorkoutType)
                    }

                let dateInterval = competitions
                    .filter { competition in
                        guard competition.isActive else { return false }
                        switch competition.scoringModel {
                        case .workout:
                            return true
                        default:
                            return false
                        }
                    }
                    .dateInterval

                return (workoutTypes, dateInterval)
            }
            .flatMapAsync { workoutTypes, dateInterval in
                try await withThrowingTaskGroup(of: (WorkoutType, [Date: [HKQuantityType: Double]]).self) { group -> [Workout] in
                    workoutTypes.forEach { workoutType, workoutMetrics in
                        group.addTask { [weak self] in
                            guard let self = self else { return (workoutType, [:]) }
                            let points = try await self.requestWorkouts(ofType: workoutType, metrics: workoutMetrics, during: dateInterval)
                            return (workoutType, points)
                        }
                    }
                    
                    var workouts = [Workout]()
                    for try await (workoutType, pointsByDateBySampleType) in group {
                        pointsByDateBySampleType.forEach { date, pointsBySampleType in
                            
                            let points = pointsBySampleType.compactMap { sampleType, points -> (WorkoutMetric, Int)? in
                                guard let metric = WorkoutMetric(from: sampleType.identifier) else { return nil }
                                return (metric, Int(points))
                            }
                            
                            let workout = Workout(
                                type: workoutType,
                                date: date,
                                points: Dictionary(uniqueKeysWithValues: points)
                            )
                            
                            workouts.append(workout)
                        }
                    }
                    return workouts
                }
            }
            .ignoreFailure()
    }
    
    private func requestWorkouts(ofType workoutType: WorkoutType, metrics: [WorkoutMetric], during dateInterval: DateInterval) async throws -> [Date: [HKQuantityType: Double]] {
        let sampleType = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: workoutType.hkWorkoutActivityType)
        let startDateSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let workouts = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKWorkout], Error>) in
            let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: [startDateSort]) { _, workouts, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let workouts = workouts?
                    .compactMap { $0 as? HKWorkout }
                    .filter { dateInterval.contains($0.startDate) && dateInterval.contains($0.endDate) }

                continuation.resume(returning: workouts ?? [])
            }
            healthKitManager.execute(query)
        }
        
        return try await withThrowingTaskGroup(of: [Date: [HKQuantityType: Double]].self) { group -> [Date: [HKQuantityType: Double]] in
            workouts.forEach { workout in
                group.addTask { [weak self] in
                    guard let self = self else { return [:] }
                    return try await self.pointsByDateByMetric(for: workout, metrics: metrics)
                }
            }
            
            var toReturn = [Date: [HKQuantityType: Double]]()
            for try await pointsByDateBySample in group {

                for (date, pointsBySampleType) in pointsByDateBySample {
                    guard let existing = toReturn[date] else {
                        toReturn[date] = pointsBySampleType
                        continue
                    }

                    toReturn[date] = pointsBySampleType
                        .enumerated()
                        .reduce(into: existing) { partialResult, next in
                            let (offset, (sampleType, points)) = next
                            switch WorkoutMetric(from: sampleType.identifier) {
                            case .heartRate:
                                let oldAverage = partialResult[sampleType] ?? 0
                                let oldTotal = oldAverage * Double(offset)
                                let newTotal = oldTotal + points
                                let newAverage = newTotal / Double(offset + 1)
                                partialResult[sampleType] = newAverage
                            case .distance, .steps, .none:
                                partialResult[sampleType] = (partialResult[sampleType] ?? 0) + points
                            }
                        }
                }
            }
            return toReturn
        }
    }
    
    /// Get the total points by date for all sample types of a given workout
    /// - Parameter workout: The workout to fetch the points for
    /// - Parameter metrics: The metrics to fetch points for
    /// - Throws: Any errors from  HealthKit
    /// - Returns: Points by date by sample type
    private func pointsByDateByMetric(for workout: HKWorkout, metrics: [WorkoutMetric]) async throws -> [Date: [HKQuantityType: Double]] {
        try await withThrowingTaskGroup(of: (HKQuantityType, [Date: Double]).self) { [weak self] group -> [Date: [HKQuantityType: Double]] in
            guard let self = self, let workoutType = WorkoutType(hkWorkoutActivityType: workout.workoutActivityType) else { return [:] }

            metrics
                .compactMap { metric -> (HKQuantityType, WorkoutMetric)? in
                    guard let sample = metric.sample(for: workoutType) else { return nil }
                    return (sample, metric)
                }
                .forEach { sample, metric in
                    group.addTask { [weak self] in
                        guard let self = self else { return (sample, [:]) }

                        let pointsByDate: [Date: Double]
                        switch metric {
                        case .steps:
                            // Steps are not actually recorded in workouts. A separate type of query is required
                            pointsByDate = await self.steps(for: workout)
                        default:
                            pointsByDate = try await self.pointsByDate(sampleType: sample, workout: workout, unit: metric.unit)
                        }
                        return (sample, pointsByDate)
                    }
                }

            var toReturn = [String: [HKQuantityType: Double]]()
            for try await (sampleType, pointsByDate) in group {
                for (date, points) in pointsByDate {
                    let dateString = DateFormatter.dateDashed.string(from: date)
                    let result = [sampleType: points]
                    guard var pointsBySampleType = toReturn[dateString] else {
                        toReturn[dateString] = result
                        continue
                    }
                    pointsBySampleType[sampleType] = (pointsBySampleType[sampleType] ?? 0) + points
                    toReturn[dateString] = pointsBySampleType
                }
            }

            return toReturn.compactMapKeys(DateFormatter.dateDashed.date(from:))
        }
    }

    /// Query HealthKit for steps that occured during a workout. Steps aren't recorded within workouts, so a separate query must be used.
    /// - Parameter workout: The workout to fetch the steps for
    /// - Returns: Steps by date
    private func steps(for workout: HKWorkout) async -> [Date: Double] {
        let dateInterval = DateInterval(start: workout.startDate, end: workout.endDate)

        let predicate = HKQuery.predicateForSamples(
            withStart: dateInterval.start,
            end: dateInterval.end
        )

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: HKQuantityType(.stepCount),
                quantitySamplePredicate: predicate) { query, stats, error in
                    let steps = stats?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    continuation.resume(returning: [workout.startDate: steps])
                }

            healthKitManager.execute(query)
        }
    }
    
    /// Get the total points by date for a given workout and sample type
    /// - Parameters:
    ///   - sampleType: The sample type to fetch the points for
    ///   - workout: The workout to fetch the points for
    ///   - unit: The unit
    /// - Throws: Any errors from HealthKit
    /// - Returns: Points by date
    private func pointsByDate(sampleType: HKQuantityType, workout: HKWorkout, unit: HKUnit) async throws -> [Date: Double] {
        // https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings/adding_samples_to_a_workout
        let predicate = HKQuery.predicateForObjects(from: workout)
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[Date: Double], Error>)  in
            let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: nil) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples else { return }
                let total = samples
                    .compactMap { $0 as? HKQuantitySample }
                    .enumerated()
                    .reduce(into: [Date: Double]()) { partialResult, next in
                        let (offset, sample) = next
                        let dateNoTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: sample.endDate)!
                        let metric = WorkoutMetric(from: sampleType.identifier)
                        switch metric {
                        case .heartRate:
                            let points = sample.quantity.doubleValue(for: unit)
                            let oldAverage = partialResult[dateNoTime] ?? 0
                            let oldTotal = oldAverage * Double(offset)
                            let newTotal = oldTotal + points
                            let newAverage = newTotal / Double(offset + 1)
                            partialResult[dateNoTime] = newAverage
                        case .distance, .steps, .none:
                            partialResult[dateNoTime] = (partialResult[dateNoTime] ?? 0) + sample.quantity.doubleValue(for: unit)
                        }
                    }
                
                continuation.resume(returning: total)
            }
            healthKitManager.execute(query)
        }
    }
}
