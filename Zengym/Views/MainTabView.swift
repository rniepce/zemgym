import SwiftUI

struct MainTabView: View {
    let profile: UserProfile
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TrainTodayView(profile: profile)
                .tabItem {
                    Label("Treinar", systemImage: "dumbbell.fill")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Label("Histórico", systemImage: "clock.fill")
                }
                .tag(1)

            ProfileView(profile: profile)
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.zenMint)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
