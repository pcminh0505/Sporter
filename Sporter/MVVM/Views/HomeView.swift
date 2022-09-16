//
//  DashboardView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem = .home
    @StateObject var notiVM = NotificationViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var discoveryVM = DiscoveryViewModel()
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            DashboardView(user: profileVM.currentUser ?? User.unset)
                .environmentObject(notiVM)
                .tabBarItem(tab: .home, selection: $tabSelection)
            
            DiscoveryView()
                .environmentObject(discoveryVM)
                .tabBarItem(tab: .explore, selection: $tabSelection)
            
            FriendListView()
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
