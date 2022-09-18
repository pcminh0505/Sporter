/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 16/09/2022
    Last modified: 18/09/2022
*/


import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var friendListVM: FriendListViewModel
    @Binding var tabSelection: TabBarItem

    var body: some View {
        VStack {
            // Heading
            Text("My Friends")
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

            if friendListVM.friendList.isEmpty {
                VStack {
                    Text("Your friend list is empty.")
                        .italic()

                    Button {
                        tabSelection = .discover
                    } label: {
                        Text("Find other gym lovers")
                            .italic()
                    }

                }
                    .font(.caption)
                    .padding()
            } else {
                List {
                    ForEach(friendListVM.friendList) { user in
                        FriendListRow(user: user)
                            .listRowInsets(.init(top: 15, leading: 15, bottom: 15, trailing: 15))
                    }
                }
                    .listStyle(PlainListStyle())
            }
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView(tabSelection: .constant(.friend))
            .environmentObject(FriendListViewModel())
    }
}
