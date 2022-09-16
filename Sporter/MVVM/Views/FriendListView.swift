//
//  FriendListView.swift
//  Sporter
//
//  Created by Minh Pham on 16/09/2022.
//

import SwiftUI

struct FriendListView: View {
    @StateObject var friendListVM = FriendListViewModel()

    var body: some View {
        VStack {
            // Heading
            Text("Friend List")
                .foregroundColor(Color.accentColor)
                .font(.title)
                .bold()
                .padding(.bottom, 0)

            List {
                ForEach(friendListVM.friendList) { user in
                    FriendListRow(user: user)
                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
//                    .listRowBackground(Color.theme.background)
            }
                .listStyle(PlainListStyle())
        }

    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
