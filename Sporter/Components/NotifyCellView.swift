//
//  ListView.swift
//  Sporter
//
//  Created by Long Tran on 10/09/2022.
//

import Foundation
import SwiftUI

struct NotifyCellView: View {
    let defaultImageURL: String = "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
    @State private var image: UIImage?
    @State private var showSheet = false
    var user: User
    @EnvironmentObject var notiVM: NotificationViewModel

    var body: some View {
        HStack {
            // Image setion
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .scaledToFill()
                    .cornerRadius(70)
                    .overlay(RoundedRectangle(cornerRadius: 70).stroke(Color.theme.textColor, lineWidth: 1))
            } else {
                AsyncImage (
                    url: URL(string: user.profileImage),
                    content: { image in
                        image.resizable()
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .scaledToFill()
                            .cornerRadius(70)
                    },
                    placeholder: {
                        ProgressView()
                            .cornerRadius(70)
                            .frame(width: 50, height: 50)
                            .background(Color(uiColor: .systemGray6))
                            .clipShape(Circle())
                    }
                )
                    .overlay(RoundedRectangle(cornerRadius: 70).stroke(Color(uiColor: .systemGray), lineWidth: 2))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("\(user.fname) \(user.lname) has sent you a friend request.")

                HStack (spacing: 10) {
                    Button(action: {
                        // Accept
                        accept_friend()
                        delete_request()
                    }, label: {
                            Text("Accept")
                                .frame(minWidth: 100)
                                .padding(.vertical)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        })
                        .padding(.vertical, 10)

                    Button(action: {
                        // Deny
                        delete_request()
                    }, label: {
                            Text("Deny")
                                .frame(minWidth: 100)
                                .padding(.vertical)
                                .foregroundColor(Color.accentColor)
                                .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor))
                        })
                        .padding(.vertical, 10)
                }
            }
                .padding(.leading)
        }
    }

    func accept_friend() {
        // update current user friend list
        var friendList: [String] = notiVM.currentUser?.friends ?? []
        friendList.append(user.id ?? "")
        notiVM.currentUser?.friends = friendList
        notiVM.updateCurrentUser()

        // update other user friend list
        var otherUser = user
        var otherFriends: [String] = otherUser.friends
        otherFriends.append(notiVM.currentUser?.id ?? "")
        otherUser.friends = otherFriends
        notiVM.updateUser(otherUser)
    }

    func delete_request() {
        let index = notiVM.getIndex(user: user)
        let match = notiVM.matches
        notiVM.deleteMatchRequest(match: match[index])
    }
}
