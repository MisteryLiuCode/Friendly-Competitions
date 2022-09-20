import Resolver
import SwiftUI
import SwiftUIX

struct UserView: View {
    
    @StateObject private var viewModel: UserViewModel
        
    init(user: User) {
        let vm = Resolver.resolve(UserViewModel.self, args: user)
        _viewModel = .init(wrappedValue: vm)
    }
    
    var body: some View {
        List {
            Section("Today's activity") {
                ActivitySummaryInfoView(activitySummary: viewModel.activitySummary)
            }

            Section("Stats") {
                StatisticsView(statistics: viewModel.statistics)
            }

            Section {
                ForEach(viewModel.actions, id: \.self) { action in
                    Button {
                        viewModel.perform(action)
                    } label: {
                        Label(action.buttonTitle, systemImage: action.systemImage)
                            .if(action.destructive) { view in
                                view.foregroundColor(.red)
                            }
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .confirmationDialog("Are you sure?", isPresented: $viewModel.confirmationRequired, titleVisibility: .visible) {
            Button("Yes", role: .destructive, action: viewModel.confirm)
            Button("Cancel", role: .cancel) {}
        }
        .registerScreenView(name: "User")
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: .gabby)
            .setupMocks()
            .embeddedInNavigationView()
    }
}
