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
                .padding(.top, 30)
                .padding()
                .padding(.vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Action Buttons
            HStack(spacing: 15) {
                Button {
                    doSwipe(rightSwipe: true)
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
                    doSwipe()
                } label: {
                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(18)
                        .background(Color.pink)
                        .clipShape(Circle())
                }
            }
                .padding(.bottom)
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
