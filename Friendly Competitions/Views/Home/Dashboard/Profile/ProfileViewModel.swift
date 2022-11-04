import Combine
import CombineExt
import ECKit
import Factory

final class ProfileViewModel: ObservableObject {

    @Published var loading = false
    @Published var user: User!
    @Published var sharedDeepLink: DeepLink!
    
    // MARK: - Private Properties
    
    @Injected(Container.authenticationManager) private var authenticationManager
    @Injected(Container.userManager) private var userManager

    private var _delete = PassthroughRelay<Void>()
    private var _signOut = PassthroughRelay<Void>()
    
    private var cancellables = Cancellables()
    
    // MARK: - Lifecycle

    init() {
        user = userManager.user
        sharedDeepLink = .friendReferral(id: userManager.user.id)
        
        $user
            .removeDuplicates()
            .compactMap { $0 }
            .flatMapLatest(withUnretained: self) { strongSelf, user in
                strongSelf.userManager
                    .update(with: user)
                    .ignoreFailure()
            }
            .sink()
            .store(in: &cancellables)
        
        userManager.userPublisher
            .removeDuplicates()
            .map(User?.init)
            .assign(to: &$user)

        _delete
            .flatMapLatest(withUnretained: self) { strongSelf in
                strongSelf.userManager
                    .deleteAccount()
                    .isLoading { [weak self] in self?.loading = $0 }
                    .ignoreFailure()
            }
            .sink()
            .store(in: &cancellables)

        _signOut
            .flatMapAsync { [weak self] in try self?.authenticationManager.signOut() }
            .sink()
            .store(in: &cancellables)
    }
    
    func deleteAccount() {
        _delete.accept()
    }
    
    func signOut() {
        _signOut.accept()
    }
}
