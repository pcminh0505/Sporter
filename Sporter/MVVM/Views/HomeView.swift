/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 09/09/2022
    Last modified: 18/09/2022
*/


import SwiftUI
import Firebase

struct HomeView: View {
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem = .home

    @StateObject var friendListVM = FriendListViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var discoveryVM = DiscoveryViewModel()

    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            DashboardView(user: profileVM.currentUser ?? User.unset)
                .tabBarItem(tab: .home, selection: $tabSelection)

            DiscoveryView()
                .environmentObject(discoveryVM)
                .tabBarItem(tab: .discover, selection: $tabSelection)

            FriendListView(tabSelection: $tabSelection)
                .environmentObject(friendListVM)
                .tabBarItem(tab: .friend, selection: $tabSelection)

            ProfileView()
                .environmentObject(profileVM)
                .tabBarItem(tab: .profile, selection: $tabSelection)
        }
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationHelper())
    }
}
