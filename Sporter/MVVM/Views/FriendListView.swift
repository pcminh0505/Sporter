//
//  FriendListView.swift
//  Sporter
//
//  Created by Minh Pham on 16/09/2022.
//

import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var friendListVM: FriendListViewModel

    var body: some View {
        VStack {
            // Heading
            Text("Friend List")
                .foregroundColor(Color.accentColor)
                .font(.title)
                .bold()
                .padding(.bottom, 0)

            VStack {
                SearchBar(searchText: $friendListVM.searchText)
                HStack {
                    Spacer()
                    Menu {
                        Picker(selection: $friendListVM.sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { value in
                                Text(value.rawValue)
                                    .tag(value)
                            }
                        } label: { }
                    } label: {
                        HStack {
                            Text(friendListVM.sortOption.rawValue)
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                            .font(.caption)
                    }
                }
            }
                .padding(.horizontal)



            List {
                ForEach(friendListVM.friendList) { user in
                    FriendListRow(user: user)
                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
                .listStyle(PlainListStyle())
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
            .environmentObject(FriendListViewModel())
    }
}
