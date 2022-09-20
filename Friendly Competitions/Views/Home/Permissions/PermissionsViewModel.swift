import Combine
import CombineExt

final class PermissionsViewModel: ObservableObject {
        
    @Published private(set) var permissionStatuses = [(Permission, PermissionStatus)]()

    private let permissionsManager: PermissionsManaging

    init(permissionsManager: PermissionsManaging) {
        self.permissionsManager = permissionsManager

        permissionsManager.permissionStatus
            .map { statuses in
                statuses
                    .map { ($0, $1) }
                    .sorted(by: \.0.rawValue)
            }
            .assign(to: &$permissionStatuses)
    }
    
    func request(_ permission: Permission) {
        permissionsManager.request(permission)
    }
}
