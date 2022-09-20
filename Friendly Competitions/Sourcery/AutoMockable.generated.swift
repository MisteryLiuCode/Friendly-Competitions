// Generated using Sourcery 1.8.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine
import HealthKit















class ActivitySummaryManagingMock: ActivitySummaryManaging {
    var activitySummary: AnyPublisher<ActivitySummary?, Never> {
        get { return underlyingActivitySummary }
        set(value) { underlyingActivitySummary = value }
    }
    var underlyingActivitySummary: AnyPublisher<ActivitySummary?, Never>!

    //MARK: - update

    var updateCallsCount = 0
    var updateCalled: Bool {
        return updateCallsCount > 0
    }
    var updateReturnValue: AnyPublisher<Void, Error>!
    var updateClosure: (() -> AnyPublisher<Void, Error>)?

    func update() -> AnyPublisher<Void, Error> {
        updateCallsCount += 1
        if let updateClosure = updateClosure {
            return updateClosure()
        } else {
            return updateReturnValue
        }
    }

}
class AnalyticsManagingMock: AnalyticsManaging {

    //MARK: - set

    var setUserIdCallsCount = 0
    var setUserIdCalled: Bool {
        return setUserIdCallsCount > 0
    }
    var setUserIdReceivedUserId: String?
    var setUserIdReceivedInvocations: [String] = []
    var setUserIdClosure: ((String) -> Void)?

    func set(userId: String) {
        setUserIdCallsCount += 1
        setUserIdReceivedUserId = userId
        setUserIdReceivedInvocations.append(userId)
        setUserIdClosure?(userId)
    }

    //MARK: - log

    var logEventCallsCount = 0
    var logEventCalled: Bool {
        return logEventCallsCount > 0
    }
    var logEventReceivedEvent: AnalyticsEvent?
    var logEventReceivedInvocations: [AnalyticsEvent] = []
    var logEventClosure: ((AnalyticsEvent) -> Void)?

    func log(event: AnalyticsEvent) {
        logEventCallsCount += 1
        logEventReceivedEvent = event
        logEventReceivedInvocations.append(event)
        logEventClosure?(event)
    }

}
class AuthenticationManagingMock: AuthenticationManaging {
    var emailVerified: AnyPublisher<Bool, Never> {
        get { return underlyingEmailVerified }
        set(value) { underlyingEmailVerified = value }
    }
    var underlyingEmailVerified: AnyPublisher<Bool, Never>!
    var loggedIn: AnyPublisher<Bool, Never> {
        get { return underlyingLoggedIn }
        set(value) { underlyingLoggedIn = value }
    }
    var underlyingLoggedIn: AnyPublisher<Bool, Never>!

    //MARK: - signIn

    var signInWithCallsCount = 0
    var signInWithCalled: Bool {
        return signInWithCallsCount > 0
    }
    var signInWithReceivedSignInMethod: SignInMethod?
    var signInWithReceivedInvocations: [SignInMethod] = []
    var signInWithReturnValue: AnyPublisher<Void, Error>!
    var signInWithClosure: ((SignInMethod) -> AnyPublisher<Void, Error>)?

    func signIn(with signInMethod: SignInMethod) -> AnyPublisher<Void, Error> {
        signInWithCallsCount += 1
        signInWithReceivedSignInMethod = signInMethod
        signInWithReceivedInvocations.append(signInMethod)
        if let signInWithClosure = signInWithClosure {
            return signInWithClosure(signInMethod)
        } else {
            return signInWithReturnValue
        }
    }

    //MARK: - signUp

    var signUpNameEmailPasswordPasswordConfirmationCallsCount = 0
    var signUpNameEmailPasswordPasswordConfirmationCalled: Bool {
        return signUpNameEmailPasswordPasswordConfirmationCallsCount > 0
    }
    var signUpNameEmailPasswordPasswordConfirmationReceivedArguments: (name: String, email: String, password: String, passwordConfirmation: String)?
    var signUpNameEmailPasswordPasswordConfirmationReceivedInvocations: [(name: String, email: String, password: String, passwordConfirmation: String)] = []
    var signUpNameEmailPasswordPasswordConfirmationReturnValue: AnyPublisher<Void, Error>!
    var signUpNameEmailPasswordPasswordConfirmationClosure: ((String, String, String, String) -> AnyPublisher<Void, Error>)?

    func signUp(name: String, email: String, password: String, passwordConfirmation: String) -> AnyPublisher<Void, Error> {
        signUpNameEmailPasswordPasswordConfirmationCallsCount += 1
        signUpNameEmailPasswordPasswordConfirmationReceivedArguments = (name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
        signUpNameEmailPasswordPasswordConfirmationReceivedInvocations.append((name: name, email: email, password: password, passwordConfirmation: passwordConfirmation))
        if let signUpNameEmailPasswordPasswordConfirmationClosure = signUpNameEmailPasswordPasswordConfirmationClosure {
            return signUpNameEmailPasswordPasswordConfirmationClosure(name, email, password, passwordConfirmation)
        } else {
            return signUpNameEmailPasswordPasswordConfirmationReturnValue
        }
    }

    //MARK: - deleteAccount

    var deleteAccountCallsCount = 0
    var deleteAccountCalled: Bool {
        return deleteAccountCallsCount > 0
    }
    var deleteAccountReturnValue: AnyPublisher<Void, Error>!
    var deleteAccountClosure: (() -> AnyPublisher<Void, Error>)?

    func deleteAccount() -> AnyPublisher<Void, Error> {
        deleteAccountCallsCount += 1
        if let deleteAccountClosure = deleteAccountClosure {
            return deleteAccountClosure()
        } else {
            return deleteAccountReturnValue
        }
    }

    //MARK: - signOut

    var signOutThrowableError: Error?
    var signOutCallsCount = 0
    var signOutCalled: Bool {
        return signOutCallsCount > 0
    }
    var signOutClosure: (() throws -> Void)?

    func signOut() throws {
        if let error = signOutThrowableError {
            throw error
        }
        signOutCallsCount += 1
        try signOutClosure?()
    }

    //MARK: - checkEmailVerification

    var checkEmailVerificationCallsCount = 0
    var checkEmailVerificationCalled: Bool {
        return checkEmailVerificationCallsCount > 0
    }
    var checkEmailVerificationReturnValue: AnyPublisher<Void, Error>!
    var checkEmailVerificationClosure: (() -> AnyPublisher<Void, Error>)?

    func checkEmailVerification() -> AnyPublisher<Void, Error> {
        checkEmailVerificationCallsCount += 1
        if let checkEmailVerificationClosure = checkEmailVerificationClosure {
            return checkEmailVerificationClosure()
        } else {
            return checkEmailVerificationReturnValue
        }
    }

    //MARK: - resendEmailVerification

    var resendEmailVerificationCallsCount = 0
    var resendEmailVerificationCalled: Bool {
        return resendEmailVerificationCallsCount > 0
    }
    var resendEmailVerificationReturnValue: AnyPublisher<Void, Error>!
    var resendEmailVerificationClosure: (() -> AnyPublisher<Void, Error>)?

    func resendEmailVerification() -> AnyPublisher<Void, Error> {
        resendEmailVerificationCallsCount += 1
        if let resendEmailVerificationClosure = resendEmailVerificationClosure {
            return resendEmailVerificationClosure()
        } else {
            return resendEmailVerificationReturnValue
        }
    }

    //MARK: - sendPasswordReset

    var sendPasswordResetToCallsCount = 0
    var sendPasswordResetToCalled: Bool {
        return sendPasswordResetToCallsCount > 0
    }
    var sendPasswordResetToReceivedEmail: String?
    var sendPasswordResetToReceivedInvocations: [String] = []
    var sendPasswordResetToReturnValue: AnyPublisher<Void, Error>!
    var sendPasswordResetToClosure: ((String) -> AnyPublisher<Void, Error>)?

    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        sendPasswordResetToCallsCount += 1
        sendPasswordResetToReceivedEmail = email
        sendPasswordResetToReceivedInvocations.append(email)
        if let sendPasswordResetToClosure = sendPasswordResetToClosure {
            return sendPasswordResetToClosure(email)
        } else {
            return sendPasswordResetToReturnValue
        }
    }

}
class CompetitionsManagingMock: CompetitionsManaging {
    var competitions: AnyPublisher<[Competition], Never> {
        get { return underlyingCompetitions }
        set(value) { underlyingCompetitions = value }
    }
    var underlyingCompetitions: AnyPublisher<[Competition], Never>!
    var invitedCompetitions: AnyPublisher<[Competition], Never> {
        get { return underlyingInvitedCompetitions }
        set(value) { underlyingInvitedCompetitions = value }
    }
    var underlyingInvitedCompetitions: AnyPublisher<[Competition], Never>!
    var standings: AnyPublisher<[Competition.ID : [Competition.Standing]], Never> {
        get { return underlyingStandings }
        set(value) { underlyingStandings = value }
    }
    var underlyingStandings: AnyPublisher<[Competition.ID : [Competition.Standing]], Never>!
    var participants: AnyPublisher<[Competition.ID: [User]], Never> {
        get { return underlyingParticipants }
        set(value) { underlyingParticipants = value }
    }
    var underlyingParticipants: AnyPublisher<[Competition.ID: [User]], Never>!
    var pendingParticipants: AnyPublisher<[Competition.ID: [User]], Never> {
        get { return underlyingPendingParticipants }
        set(value) { underlyingPendingParticipants = value }
    }
    var underlyingPendingParticipants: AnyPublisher<[Competition.ID: [User]], Never>!
    var appOwnedCompetitions: AnyPublisher<[Competition], Never> {
        get { return underlyingAppOwnedCompetitions }
        set(value) { underlyingAppOwnedCompetitions = value }
    }
    var underlyingAppOwnedCompetitions: AnyPublisher<[Competition], Never>!
    var topCommunityCompetitions: AnyPublisher<[Competition], Never> {
        get { return underlyingTopCommunityCompetitions }
        set(value) { underlyingTopCommunityCompetitions = value }
    }
    var underlyingTopCommunityCompetitions: AnyPublisher<[Competition], Never>!

    //MARK: - accept

    var acceptCallsCount = 0
    var acceptCalled: Bool {
        return acceptCallsCount > 0
    }
    var acceptReceivedCompetition: Competition?
    var acceptReceivedInvocations: [Competition] = []
    var acceptReturnValue: AnyPublisher<Void, Error>!
    var acceptClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func accept(_ competition: Competition) -> AnyPublisher<Void, Error> {
        acceptCallsCount += 1
        acceptReceivedCompetition = competition
        acceptReceivedInvocations.append(competition)
        if let acceptClosure = acceptClosure {
            return acceptClosure(competition)
        } else {
            return acceptReturnValue
        }
    }

    //MARK: - create

    var createCallsCount = 0
    var createCalled: Bool {
        return createCallsCount > 0
    }
    var createReceivedCompetition: Competition?
    var createReceivedInvocations: [Competition] = []
    var createReturnValue: AnyPublisher<Void, Error>!
    var createClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func create(_ competition: Competition) -> AnyPublisher<Void, Error> {
        createCallsCount += 1
        createReceivedCompetition = competition
        createReceivedInvocations.append(competition)
        if let createClosure = createClosure {
            return createClosure(competition)
        } else {
            return createReturnValue
        }
    }

    //MARK: - decline

    var declineCallsCount = 0
    var declineCalled: Bool {
        return declineCallsCount > 0
    }
    var declineReceivedCompetition: Competition?
    var declineReceivedInvocations: [Competition] = []
    var declineReturnValue: AnyPublisher<Void, Error>!
    var declineClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func decline(_ competition: Competition) -> AnyPublisher<Void, Error> {
        declineCallsCount += 1
        declineReceivedCompetition = competition
        declineReceivedInvocations.append(competition)
        if let declineClosure = declineClosure {
            return declineClosure(competition)
        } else {
            return declineReturnValue
        }
    }

    //MARK: - delete

    var deleteCallsCount = 0
    var deleteCalled: Bool {
        return deleteCallsCount > 0
    }
    var deleteReceivedCompetition: Competition?
    var deleteReceivedInvocations: [Competition] = []
    var deleteReturnValue: AnyPublisher<Void, Error>!
    var deleteClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func delete(_ competition: Competition) -> AnyPublisher<Void, Error> {
        deleteCallsCount += 1
        deleteReceivedCompetition = competition
        deleteReceivedInvocations.append(competition)
        if let deleteClosure = deleteClosure {
            return deleteClosure(competition)
        } else {
            return deleteReturnValue
        }
    }

    //MARK: - invite

    var inviteToCallsCount = 0
    var inviteToCalled: Bool {
        return inviteToCallsCount > 0
    }
    var inviteToReceivedArguments: (user: User, competition: Competition)?
    var inviteToReceivedInvocations: [(user: User, competition: Competition)] = []
    var inviteToReturnValue: AnyPublisher<Void, Error>!
    var inviteToClosure: ((User, Competition) -> AnyPublisher<Void, Error>)?

    func invite(_ user: User, to competition: Competition) -> AnyPublisher<Void, Error> {
        inviteToCallsCount += 1
        inviteToReceivedArguments = (user: user, competition: competition)
        inviteToReceivedInvocations.append((user: user, competition: competition))
        if let inviteToClosure = inviteToClosure {
            return inviteToClosure(user, competition)
        } else {
            return inviteToReturnValue
        }
    }

    //MARK: - join

    var joinCallsCount = 0
    var joinCalled: Bool {
        return joinCallsCount > 0
    }
    var joinReceivedCompetition: Competition?
    var joinReceivedInvocations: [Competition] = []
    var joinReturnValue: AnyPublisher<Void, Error>!
    var joinClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func join(_ competition: Competition) -> AnyPublisher<Void, Error> {
        joinCallsCount += 1
        joinReceivedCompetition = competition
        joinReceivedInvocations.append(competition)
        if let joinClosure = joinClosure {
            return joinClosure(competition)
        } else {
            return joinReturnValue
        }
    }

    //MARK: - leave

    var leaveCallsCount = 0
    var leaveCalled: Bool {
        return leaveCallsCount > 0
    }
    var leaveReceivedCompetition: Competition?
    var leaveReceivedInvocations: [Competition] = []
    var leaveReturnValue: AnyPublisher<Void, Error>!
    var leaveClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func leave(_ competition: Competition) -> AnyPublisher<Void, Error> {
        leaveCallsCount += 1
        leaveReceivedCompetition = competition
        leaveReceivedInvocations.append(competition)
        if let leaveClosure = leaveClosure {
            return leaveClosure(competition)
        } else {
            return leaveReturnValue
        }
    }

    //MARK: - update

    var updateCallsCount = 0
    var updateCalled: Bool {
        return updateCallsCount > 0
    }
    var updateReceivedCompetition: Competition?
    var updateReceivedInvocations: [Competition] = []
    var updateReturnValue: AnyPublisher<Void, Error>!
    var updateClosure: ((Competition) -> AnyPublisher<Void, Error>)?

    func update(_ competition: Competition) -> AnyPublisher<Void, Error> {
        updateCallsCount += 1
        updateReceivedCompetition = competition
        updateReceivedInvocations.append(competition)
        if let updateClosure = updateClosure {
            return updateClosure(competition)
        } else {
            return updateReturnValue
        }
    }

    //MARK: - search

    var searchCallsCount = 0
    var searchCalled: Bool {
        return searchCallsCount > 0
    }
    var searchReceivedSearchText: String?
    var searchReceivedInvocations: [String] = []
    var searchReturnValue: AnyPublisher<[Competition], Error>!
    var searchClosure: ((String) -> AnyPublisher<[Competition], Error>)?

    func search(_ searchText: String) -> AnyPublisher<[Competition], Error> {
        searchCallsCount += 1
        searchReceivedSearchText = searchText
        searchReceivedInvocations.append(searchText)
        if let searchClosure = searchClosure {
            return searchClosure(searchText)
        } else {
            return searchReturnValue
        }
    }

    //MARK: - search

    var searchByIDCallsCount = 0
    var searchByIDCalled: Bool {
        return searchByIDCallsCount > 0
    }
    var searchByIDReceivedCompetitionID: Competition.ID?
    var searchByIDReceivedInvocations: [Competition.ID] = []
    var searchByIDReturnValue: AnyPublisher<Competition?, Error>!
    var searchByIDClosure: ((Competition.ID) -> AnyPublisher<Competition?, Error>)?

    func search(byID competitionID: Competition.ID) -> AnyPublisher<Competition?, Error> {
        searchByIDCallsCount += 1
        searchByIDReceivedCompetitionID = competitionID
        searchByIDReceivedInvocations.append(competitionID)
        if let searchByIDClosure = searchByIDClosure {
            return searchByIDClosure(competitionID)
        } else {
            return searchByIDReturnValue
        }
    }

    //MARK: - updateStandings

    var updateStandingsCallsCount = 0
    var updateStandingsCalled: Bool {
        return updateStandingsCallsCount > 0
    }
    var updateStandingsReturnValue: AnyPublisher<Void, Error>!
    var updateStandingsClosure: (() -> AnyPublisher<Void, Error>)?

    func updateStandings() -> AnyPublisher<Void, Error> {
        updateStandingsCallsCount += 1
        if let updateStandingsClosure = updateStandingsClosure {
            return updateStandingsClosure()
        } else {
            return updateStandingsReturnValue
        }
    }

}
class FriendsManagingMock: FriendsManaging {
    var friends: AnyPublisher<[User], Never> {
        get { return underlyingFriends }
        set(value) { underlyingFriends = value }
    }
    var underlyingFriends: AnyPublisher<[User], Never>!
    var friendActivitySummaries: AnyPublisher<[User.ID: ActivitySummary], Never> {
        get { return underlyingFriendActivitySummaries }
        set(value) { underlyingFriendActivitySummaries = value }
    }
    var underlyingFriendActivitySummaries: AnyPublisher<[User.ID: ActivitySummary], Never>!
    var friendRequests: AnyPublisher<[User], Never> {
        get { return underlyingFriendRequests }
        set(value) { underlyingFriendRequests = value }
    }
    var underlyingFriendRequests: AnyPublisher<[User], Never>!

    //MARK: - add

    var addFriendCallsCount = 0
    var addFriendCalled: Bool {
        return addFriendCallsCount > 0
    }
    var addFriendReceivedFriend: User?
    var addFriendReceivedInvocations: [User] = []
    var addFriendReturnValue: AnyPublisher<Void, Error>!
    var addFriendClosure: ((User) -> AnyPublisher<Void, Error>)?

    func add(friend: User) -> AnyPublisher<Void, Error> {
        addFriendCallsCount += 1
        addFriendReceivedFriend = friend
        addFriendReceivedInvocations.append(friend)
        if let addFriendClosure = addFriendClosure {
            return addFriendClosure(friend)
        } else {
            return addFriendReturnValue
        }
    }

    //MARK: - acceptFriendRequest

    var acceptFriendRequestFromCallsCount = 0
    var acceptFriendRequestFromCalled: Bool {
        return acceptFriendRequestFromCallsCount > 0
    }
    var acceptFriendRequestFromReceivedFrom: User?
    var acceptFriendRequestFromReceivedInvocations: [User] = []
    var acceptFriendRequestFromReturnValue: AnyPublisher<Void, Error>!
    var acceptFriendRequestFromClosure: ((User) -> AnyPublisher<Void, Error>)?

    func acceptFriendRequest(from: User) -> AnyPublisher<Void, Error> {
        acceptFriendRequestFromCallsCount += 1
        acceptFriendRequestFromReceivedFrom = from
        acceptFriendRequestFromReceivedInvocations.append(from)
        if let acceptFriendRequestFromClosure = acceptFriendRequestFromClosure {
            return acceptFriendRequestFromClosure(from)
        } else {
            return acceptFriendRequestFromReturnValue
        }
    }

    //MARK: - declineFriendRequest

    var declineFriendRequestFromCallsCount = 0
    var declineFriendRequestFromCalled: Bool {
        return declineFriendRequestFromCallsCount > 0
    }
    var declineFriendRequestFromReceivedFrom: User?
    var declineFriendRequestFromReceivedInvocations: [User] = []
    var declineFriendRequestFromReturnValue: AnyPublisher<Void, Error>!
    var declineFriendRequestFromClosure: ((User) -> AnyPublisher<Void, Error>)?

    func declineFriendRequest(from: User) -> AnyPublisher<Void, Error> {
        declineFriendRequestFromCallsCount += 1
        declineFriendRequestFromReceivedFrom = from
        declineFriendRequestFromReceivedInvocations.append(from)
        if let declineFriendRequestFromClosure = declineFriendRequestFromClosure {
            return declineFriendRequestFromClosure(from)
        } else {
            return declineFriendRequestFromReturnValue
        }
    }

    //MARK: - delete

    var deleteFriendCallsCount = 0
    var deleteFriendCalled: Bool {
        return deleteFriendCallsCount > 0
    }
    var deleteFriendReceivedFriend: User?
    var deleteFriendReceivedInvocations: [User] = []
    var deleteFriendReturnValue: AnyPublisher<Void, Error>!
    var deleteFriendClosure: ((User) -> AnyPublisher<Void, Error>)?

    func delete(friend: User) -> AnyPublisher<Void, Error> {
        deleteFriendCallsCount += 1
        deleteFriendReceivedFriend = friend
        deleteFriendReceivedInvocations.append(friend)
        if let deleteFriendClosure = deleteFriendClosure {
            return deleteFriendClosure(friend)
        } else {
            return deleteFriendReturnValue
        }
    }

    //MARK: - user

    var userWithIdCallsCount = 0
    var userWithIdCalled: Bool {
        return userWithIdCallsCount > 0
    }
    var userWithIdReceivedId: String?
    var userWithIdReceivedInvocations: [String] = []
    var userWithIdReturnValue: AnyPublisher<User?, Error>!
    var userWithIdClosure: ((String) -> AnyPublisher<User?, Error>)?

    func user(withId id: String) -> AnyPublisher<User?, Error> {
        userWithIdCallsCount += 1
        userWithIdReceivedId = id
        userWithIdReceivedInvocations.append(id)
        if let userWithIdClosure = userWithIdClosure {
            return userWithIdClosure(id)
        } else {
            return userWithIdReturnValue
        }
    }

    //MARK: - search

    var searchWithCallsCount = 0
    var searchWithCalled: Bool {
        return searchWithCallsCount > 0
    }
    var searchWithReceivedText: String?
    var searchWithReceivedInvocations: [String] = []
    var searchWithReturnValue: AnyPublisher<[User], Error>!
    var searchWithClosure: ((String) -> AnyPublisher<[User], Error>)?

    func search(with text: String) -> AnyPublisher<[User], Error> {
        searchWithCallsCount += 1
        searchWithReceivedText = text
        searchWithReceivedInvocations.append(text)
        if let searchWithClosure = searchWithClosure {
            return searchWithClosure(text)
        } else {
            return searchWithReturnValue
        }
    }

}
class HealthKitManagingMock: HealthKitManaging {
    var backgroundDeliveryReceived: AnyPublisher<Void, Never> {
        get { return underlyingBackgroundDeliveryReceived }
        set(value) { underlyingBackgroundDeliveryReceived = value }
    }
    var underlyingBackgroundDeliveryReceived: AnyPublisher<Void, Never>!
    var permissionStatus: AnyPublisher<PermissionStatus, Never> {
        get { return underlyingPermissionStatus }
        set(value) { underlyingPermissionStatus = value }
    }
    var underlyingPermissionStatus: AnyPublisher<PermissionStatus, Never>!

    //MARK: - execute

    var executeCallsCount = 0
    var executeCalled: Bool {
        return executeCallsCount > 0
    }
    var executeReceivedQuery: HKQuery?
    var executeReceivedInvocations: [HKQuery] = []
    var executeClosure: ((HKQuery) -> Void)?

    func execute(_ query: HKQuery) {
        executeCallsCount += 1
        executeReceivedQuery = query
        executeReceivedInvocations.append(query)
        executeClosure?(query)
    }

    //MARK: - requestPermissions

    var requestPermissionsCallsCount = 0
    var requestPermissionsCalled: Bool {
        return requestPermissionsCallsCount > 0
    }
    var requestPermissionsClosure: (() -> Void)?

    func requestPermissions() {
        requestPermissionsCallsCount += 1
        requestPermissionsClosure?()
    }

}
class NotificationManagingMock: NotificationManaging {
    var permissionStatus: AnyPublisher<PermissionStatus, Never> {
        get { return underlyingPermissionStatus }
        set(value) { underlyingPermissionStatus = value }
    }
    var underlyingPermissionStatus: AnyPublisher<PermissionStatus, Never>!

    //MARK: - requestPermissions

    var requestPermissionsCallsCount = 0
    var requestPermissionsCalled: Bool {
        return requestPermissionsCallsCount > 0
    }
    var requestPermissionsClosure: (() -> Void)?

    func requestPermissions() {
        requestPermissionsCallsCount += 1
        requestPermissionsClosure?()
    }

}
class PermissionsManagingMock: PermissionsManaging {
    var requiresPermission: AnyPublisher<Bool, Never> {
        get { return underlyingRequiresPermission }
        set(value) { underlyingRequiresPermission = value }
    }
    var underlyingRequiresPermission: AnyPublisher<Bool, Never>!
    var permissionStatus: AnyPublisher<[Permission: PermissionStatus], Never> {
        get { return underlyingPermissionStatus }
        set(value) { underlyingPermissionStatus = value }
    }
    var underlyingPermissionStatus: AnyPublisher<[Permission: PermissionStatus], Never>!

    //MARK: - request

    var requestCallsCount = 0
    var requestCalled: Bool {
        return requestCallsCount > 0
    }
    var requestReceivedPermission: Permission?
    var requestReceivedInvocations: [Permission] = []
    var requestClosure: ((Permission) -> Void)?

    func request(_ permission: Permission) {
        requestCallsCount += 1
        requestReceivedPermission = permission
        requestReceivedInvocations.append(permission)
        requestClosure?(permission)
    }

}
class StorageManagingMock: StorageManaging {

    //MARK: - data

    var dataForThrowableError: Error?
    var dataForCallsCount = 0
    var dataForCalled: Bool {
        return dataForCallsCount > 0
    }
    var dataForReceivedStoragePath: String?
    var dataForReceivedInvocations: [String] = []
    var dataForReturnValue: Data!
    var dataForClosure: ((String) async throws -> Data)?

    func data(for storagePath: String) async throws -> Data {
        if let error = dataForThrowableError {
            throw error
        }
        dataForCallsCount += 1
        dataForReceivedStoragePath = storagePath
        dataForReceivedInvocations.append(storagePath)
        if let dataForClosure = dataForClosure {
            return try await dataForClosure(storagePath)
        } else {
            return dataForReturnValue
        }
    }

}
class UserManagingMock: UserManaging {
    var user: CurrentValueSubject<User, Never> {
        get { return underlyingUser }
        set(value) { underlyingUser = value }
    }
    var underlyingUser: CurrentValueSubject<User, Never>!

    //MARK: - deleteAccount

    var deleteAccountCallsCount = 0
    var deleteAccountCalled: Bool {
        return deleteAccountCallsCount > 0
    }
    var deleteAccountReturnValue: AnyPublisher<Void, Error>!
    var deleteAccountClosure: (() -> AnyPublisher<Void, Error>)?

    func deleteAccount() -> AnyPublisher<Void, Error> {
        deleteAccountCallsCount += 1
        if let deleteAccountClosure = deleteAccountClosure {
            return deleteAccountClosure()
        } else {
            return deleteAccountReturnValue
        }
    }

    //MARK: - update

    var updateWithCallsCount = 0
    var updateWithCalled: Bool {
        return updateWithCallsCount > 0
    }
    var updateWithReceivedUser: User?
    var updateWithReceivedInvocations: [User] = []
    var updateWithClosure: ((User) -> Void)?

    func update(with user: User) {
        updateWithCallsCount += 1
        updateWithReceivedUser = user
        updateWithReceivedInvocations.append(user)
        updateWithClosure?(user)
    }

}
