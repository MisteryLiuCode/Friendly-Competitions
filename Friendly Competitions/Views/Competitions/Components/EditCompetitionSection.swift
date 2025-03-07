import ECKit
import SwiftUI
import SwiftUIX

struct EditCompetitionSection: View {

    private enum UnderlyingScoringModel: String, CaseIterable, CustomStringConvertible, Identifiable {
        case percentOfGoals = "Percent of Goals"
        case rawNumbers = "Raw Numbers"
        case workout = "Workout"

        var id: RawValue { description }
        var description: String { rawValue }
    }
    
    // MARK: - Public Properties
    
    @Binding var name: String
    @Binding var scoringModel: Competition.ScoringModel
    @Binding var start: Date
    @Binding var end: Date
    @Binding var repeats: Bool
    @Binding var isPublic: Bool
    
    // MARK: - Private Properties

    @State private var underlyingScoringModel: UnderlyingScoringModel?
    @State private var underlyingWorkoutType: WorkoutType?
    @State private var underlyingWorkoutMetrics: [WorkoutMetric] = []

    private var newScoringModel: Competition.ScoringModel? {
        switch underlyingScoringModel {
        case .percentOfGoals:
            return .percentOfGoals
        case .rawNumbers:
            return .rawNumbers
        case .workout:
            if let underlyingWorkoutType, !underlyingWorkoutMetrics.isEmpty {
                return .workout(underlyingWorkoutType, underlyingWorkoutMetrics)
            }
            return nil
        case .none:
            return nil
        }
    }

    private var detailsFooterTexts: [String] {
        var detailsTexts = [String]()
        if repeats {
            detailsTexts.append("This competition will restart the next day after it ends.")
        }
        if isPublic {
            detailsTexts.append("Heads up! Anyone can join public competitions from the explore page.")
        }
        return detailsTexts
    }
    
    // MARK: - Lifecycle
    
    init(name: Binding<String>, scoringModel: Binding<Competition.ScoringModel>, start: Binding<Date>, end: Binding<Date>, repeats: Binding<Bool>, isPublic: Binding<Bool>) {
        _name = name
        _scoringModel = scoringModel
        _start = start
        _end = end
        _repeats = repeats
        _isPublic = isPublic
        
        switch scoringModel.wrappedValue {
        case .percentOfGoals:
            _underlyingScoringModel = .init(initialValue: .percentOfGoals)
        case .rawNumbers:
            _underlyingScoringModel = .init(initialValue: .rawNumbers)
        case .workout(let type, let metrics):
            _underlyingScoringModel = .init(initialValue: .workout)
            _underlyingWorkoutType = .init(initialValue: type)
            _underlyingWorkoutMetrics = .init(initialValue: metrics)
        }
    }
    
    // MARK: - View
    
    var body: some View {
        Section {
            TextField("Name", text: $name)
            
            DatePicker(
                "Starts",
                selection: $start,
                in: PartialRangeFrom(min(start, Date())),
                displayedComponents: [.date]
            )
            DatePicker(
                "Ends",
                selection: $end,
                in: PartialRangeFrom(start.addingTimeInterval(1.days)),
                displayedComponents: [.date]
            )

            EnumPicker("ScoringModel", selection: $underlyingScoringModel)

            if underlyingScoringModel == .workout {
                EnumPicker("Workout type", selection: $underlyingWorkoutType, allowsNoSelection: true)

                if let underlyingWorkoutType {
                    MultiPicker(
                        title: "Workout metrics",
                        selection: $underlyingWorkoutMetrics,
                        options: underlyingWorkoutType.metrics
                    )
                }
            }

            Toggle("Repeats", isOn: $repeats)
            Toggle("Public", isOn: $isPublic)
        } header: {
            Text("Details")
        } footer: {
            if detailsFooterTexts.isNotEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(detailsFooterTexts, id: \.self, content: Text.init)
                }
            }
        }
        .onChange(of: newScoringModel) { newScoringModel in
            guard let newScoringModel else { return }
            scoringModel = newScoringModel
        }
    }
}

#if DEBUG
struct EditCompetitionView_Previews: PreviewProvider {

    private struct Preview: View {

        @State private var competition: Competition = .mock

        var body: some View {
            Form {
                EditCompetitionSection(
                    name: $competition.name,
                    scoringModel: $competition.scoringModel,
                    start: $competition.start,
                    end: $competition.end,
                    repeats: $competition.repeats,
                    isPublic: $competition.isPublic
                )
            }
        }
    }

    static var previews: some View {
        Preview()
            .navigationTitle("Competition Info")
            .embeddedInNavigationView()
    }
}
#endif
