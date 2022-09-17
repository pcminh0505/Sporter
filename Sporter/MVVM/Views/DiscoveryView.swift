//
//  Home.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation
import SwiftUI

struct DiscoveryView: View {
    @StateObject var discoveryVM = DiscoveryViewModel()

    var body: some View {
        VStack {
            // Heading
            Text("Explore People")
                .foregroundColor(Color.accentColor)
                .font(.title)
                .bold()
                .padding(.bottom, 0)

            // Users Stack
            ZStack {
                if let users = discoveryVM.displayingUsers {
                    if users.isEmpty {
                        Text("Come back later we can find more matches for you")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    else {
                        // Display users
                        ForEach(users.reversed()) { user in
                            // Card View
                            StackCardView(user: user)
                                .environmentObject(discoveryVM)
                        }
                    }
                }
                else {
                    ProgressView()
                }
            }
                .padding(.top, 0)
                .padding()
                .padding(.vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Action Buttons
            HStack(spacing: 15) {

                Image(systemName: "arrow.backward")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(Color.blue)
                    .shadow(radius: 5)
                    .padding(18)
                
                Text("Skip")
                    .foregroundColor(Color.blue)
                    .font(.caption)
                    .bold()
                    .padding(.bottom, 0)

                Button {
                    doSwipe()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(18)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button {
                    doSwipe(rightSwipe: true)
                } label: {
                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(18)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                
                Text("Add Friend")
                    .foregroundColor(Color.accentColor)
                    .font(.caption)
                    .bold()
                    .padding(.bottom, 0)

                Image(systemName: "arrow.right")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(Color.accentColor)
                    .shadow(radius: 5)
                    .padding(18)
            }
            .padding(.top, 10)
                .disabled(discoveryVM.displayingUsers.isEmpty)
                .opacity((discoveryVM.displayingUsers.isEmpty) ? 0.6 : 1)
        }
    }

    func doSwipe(rightSwipe: Bool = false) {
        guard let first = discoveryVM.displayingUsers.first else {
            return
        }

        // Use Notifications to post and recieving in Stack
        NotificationCenter.default.post(name: NSNotification.Name("ACTIONFROMBUTTON"), object: nil, userInfo: [
                "id": first.id ?? "",
                "rightSwipe": rightSwipe
            ])
    }
}

struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
    }
}
