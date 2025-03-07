import SwiftUI
import SwiftUIX

struct DashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
            
    @State private var presentAbout = false
    @State private var presentDeveloper = false
    @State private var presentPermissions = false
    @State private var presentNewCompetition = false
    @State private var presentSearchFriendsSheet = false
    @AppStorage("competitionsFiltered") var competitionsFiltered = false
    
    var body: some View {
        List {
            Group {
                activitySummary
                competitions
                friends
            }
            .textCase(nil)
        }
        .navigationBarTitle(viewModel.title)
        .toolbar {
            HStack {
                if viewModel.showDeveloper {
                    Button(toggling: $presentDeveloper) {
                        Image(systemName: .hammer)
                    }
                }
                Button(toggling: $presentAbout) {
                    Image(systemName: .questionmarkCircle)
                }
                NavigationLink {
                    Profile()
                } label: {
                    Image(systemName: .personCropCircle)
                }
            }
        }
        .sheet(isPresented: $presentAbout) { About() }
        .sheet(isPresented: $presentSearchFriendsSheet) { InviteFriendsView(action: .addFriend) }
        .sheet(isPresented: $presentNewCompetition) { NewCompetitionView() }
        .sheet(isPresented: $viewModel.requiresPermissions) { PermissionsView() }
        .sheet(isPresented: $presentDeveloper) { DeveloperView() }
        .registerScreenView(name: "Dashboard")
    }
    
    private var activitySummary: some View {
        Section {
            ActivitySummaryInfoView(activitySummary: viewModel.activitySummary)
        } header: {
            Text("Activity").font(.title3)
        } footer: {
            if viewModel.activitySummary == nil {
                Text("Have you worn your watch today? We can't find any activity summaries yet. If this is a mistake, please make sure that permissions are enabled in the Health app.")
            }
        }
    }
    
    private var competitions: some View {
        Section {
            ForEach(viewModel.competitions) { competition in
                if competitionsFiltered ? competition.isActive : true {
                    CompetitionDetails(competition: competition, showParticipantCount: false, isFeatured: false)
                }
            }
            ForEach(viewModel.invitedCompetitions) { competition in
                if competitionsFiltered ? competition.isActive : true {
                    CompetitionDetails(competition: competition, showParticipantCount: false, isFeatured: false)
                }
            }
        } header: {
            HStack {
                let text = competitionsFiltered ? "Active competitions" : "Competitions"
                Text(text).font(.title3)
                Spacer()
                Button {
                    withAnimation { competitionsFiltered.toggle() }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle\(competitionsFiltered ? ".fill" : "")")
                        .font(.title2)
                }
                .disabled(viewModel.competitions.isEmpty)
                
                Button(toggling: $presentNewCompetition) {
                    Image(systemName: .plusCircle)
                        .font(.title2)
                }
            }
        } footer: {
            if viewModel.competitions.isEmpty && viewModel.invitedCompetitions.isEmpty {
                Text("Start a competition against your friends!")
            }
        }
    }
    
    private var friends: some View {
        Section {
            ForEach(viewModel.friends) { row in
                NavigationLink {
                    UserView(user: row.user)
                } label: {
                    HStack {
                        ActivityRingView(activitySummary: row.activitySummary?.hkActivitySummary)
                            .frame(width: 35, height: 35)
                        Text(row.user.name)
                        Spacer()
                        if row.isInvitation {
                            Text("Invited")
                                .foregroundColor(.secondaryLabel)
                        }
                    }
                }
            }
        } header: {
            HStack {
                Text("Friends")
                    .font(.title3)
                Spacer()
                Button(toggling: $presentSearchFriendsSheet) {
                    Image(systemName: .personCropCircleBadgePlus)
                        .font(.title2)
                }
            }
        } footer: {
            if viewModel.friends.isEmpty {
                Text("Add friends to get started!")
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    
    private static func setupMocks() {
        activitySummaryManager.activitySummary = .just(.mock)
        
        let competitions: [Competition] = [.mock, .mockInvited, .mockOld, .mockPublic]
        let participants = competitions.reduce(into: [Competition.ID: [User]]()) { partialResult, competition in
            partialResult[competition.id] = [.evan]
        }
        let standings = competitions.reduce(into: [Competition.ID: [Competition.Standing]]()) { partialResult, competition in
            partialResult[competition.id] = [.mock(for: .evan)]
        }
        competitionsManager.competitions = .just(competitions)
        competitionsManager.participants = .just(participants)
        competitionsManager.standings = .just(standings)

        friendsManager.friends = .just([.gabby])
        friendsManager.friendRequests = .just([.andrew])
        friendsManager.friendActivitySummaries = .just([User.gabby.id: .mock])
        
        permissionsManager.requiresPermission = .just(false)
        permissionsManager.permissionStatus = .just([
            .health: .authorized,
            .notifications: .authorized
        ])
    }
    
    static var previews: some View {
        DashboardView()
            .setupMocks(setupMocks)
            .embeddedInNavigationView()
    }
}
