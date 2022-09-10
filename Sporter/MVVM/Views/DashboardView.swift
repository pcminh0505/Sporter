//
//  DashboardView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    @EnvironmentObject var dashboardVM: HomeViewModel
    @EnvironmentObject var navigationHelper: NavigationHelper

    var body: some View {
        VStack {
            NavigationLink(tag: "map", selection: $navigationHelper.selection) {
                MapView().navigationBarHidden(true)
            } label: {
                EmptyView()
            }.isDetailLink(false)

            Text("Hello \(dashboardVM.currentUser?.fname ?? "fname") \(dashboardVM.currentUser?.lname ?? "lname")")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.textColor)

            Button {
                navigationHelper.selection = "map"
            } label: {
                HStack {
                    Text("Go to Map")
                    Image(systemName: "map.fill")
                }
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .foregroundColor(.white)
            }
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.top, 25)

            Button {
                navigationHelper.selection = "discover"
            } label: {
                HStack {
                    Text("Go to Discover")
                    Image(systemName: "person.2.fill")
                }
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .foregroundColor(.white)
            }
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.top, 25)


            Button(action: {
                try! Auth.auth().signOut()
                UserDefaults.standard.set("", forKey: "currentUser")
                UserDefaults.standard.set(false, forKey: "authStatus")
                NotificationCenter.default.post(name: NSNotification.Name("authStatus"), object: nil)

            }) {
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.top, 25)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}