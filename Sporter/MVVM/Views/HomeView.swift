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

    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            DashboardView()
                .tabBarItem(tab: .home, selection: $tabSelection)
                
            DiscoveryView()
                .tabBarItem(tab: .explore, selection: $tabSelection)

            ChatView()
                .tabBarItem(tab: .messages, selection: $tabSelection)

            ProfileView()
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
