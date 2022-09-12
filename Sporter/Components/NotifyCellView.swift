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
                HStack() {
                    Button {
                        // Accept
                        accept_friend()
                        delete_request()
                        print("Accepted RQ")
                    } label: {
                        Text("ACCEPT")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color.accentColor)
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Button {
                        // Deny
                        delete_request()
                        print("Reject RQ")
                    } label: {
                        Text("DENY")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color.accentColor)
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
    
    func accept_friend() {
        var friendList: [String] = notiVM.currentUser?.friends ?? []
        friendList.append(user.id ?? "")
        notiVM.currentUser?.friends = friendList
        notiVM.updateUser()
    }
    
    func delete_request() {
        let index = notiVM.getIndex(user: user)
        let match = notiVM.matches
        notiVM.deleteMatchRequest(match: match[index])
    }
}