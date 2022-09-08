//
//  HomeView.swift
//  Sporter
//
//  Created by Minh Pham on 31/08/2022.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State var selectedTab: Int = 0

    var body: some View {
        ScrollView {
            TabView {
                VStack {
                    Text("Logged successfully")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(0.7))

                    Button(action: {

                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)

                    }) {

                        Text("Log out")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top, 25)
                }
                    .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                    .tag(0)

                MapView()
                    .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                    .tag(1)

                DiscoveryView()
                    .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Connecting")
                }
                    .tag(2)
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(VenueViewModel())
    }
}
