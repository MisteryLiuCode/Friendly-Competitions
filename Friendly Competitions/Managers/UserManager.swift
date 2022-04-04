import Combine
import Firebase
import FirebaseCrashlytics
import FirebaseFirestore
import Resolver

class AnyUserManager: ObservableObject {
    @Published var user: User

    init(user: User) {
        self.user = user
    }

    func deleteAccount() {}
    func signOut() {}
}

final class UserManager: AnyUserManager {

    @Injected private var analyticsManager: AnyAnalyticsManager
    @Injected private var database: Firestore

    private var userListener: ListenerRegistration?

    private var cancellables = Set<AnyCancellable>()

    override init(user: User) {
        super.init(user: user)
        listenForUser()

        $user
            .dropFirst(2) // 1: init, 2: local listener
            .removeDuplicates()
            .sinkAsync { [weak self] newUser in
                print(newUser)
                try await self?.update()
            }
            .store(in: &cancellables)
    }

    deinit {
        userListener?.remove()
        userListener = nil
    }

    override func deleteAccount() {
        Task {
            try await database.document("users/\(user.id)").delete()
            try await Auth.auth().currentUser?.delete()
        }
    }

    override func signOut() {
        try? Auth.auth().signOut()
    }

    // MARK: - Private Methods

    private func update() async throws {
        try await database.document("users/\(user.id)").updateDataEncodable(user)
    }

    private func listenForUser() {
        userListener = database.document("users/\(user.id)")
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self, let user = try? snapshot?.decoded(as: User.self) else { return }
                self.analyticsManager.set(userId: user.id)
                self.user = user
            }
    }
}
