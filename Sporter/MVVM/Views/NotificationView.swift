/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Long Tran
    ID: s3755615
    Created date: 10/09/2022
    Last modified: 18/09/2022
*/

import Foundation
import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notiVM: NotificationViewModel
    @EnvironmentObject var navigationHelper: NavigationHelper

    let matchRepo: MatchRepository = MatchRepository()
    let userRepo: UserRepository = UserRepository()

    @State private var singleSelection: UUID?

    var body: some View {
        VStack {
            // Top Nav Bar
            Button {
                navigationHelper.selection = nil
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                Text("Friend Requests")
                    .font(.title)
                    .bold()
            )
                .foregroundColor(Color.accentColor)
                .padding()

            // Heading
            ZStack {
                if let matchRequest = notiVM.currentUserMatch
                {
                    if matchRequest.isEmpty {
                        Text("No friend request received yet")
                            .italic()
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    else {
                        List(selection: $singleSelection) {
                            ForEach(matchRequest) { user in
                                NotifyCellView(user: user)
                                    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                                    .environmentObject(notiVM)
                            }
                        }
                    }
                }
                else {
                    ProgressView()
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .environmentObject(NotificationViewModel())
    }
}

