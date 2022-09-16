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
            
            // Top Nav Bar
            Button {
            } label: {
                
                Image(systemName: "list.dash")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
            }
            .frame(maxWidth: .infinity, alignment: .leading )
            .overlay(
                Text("Discovery")
                    .font(.title.bold())
            )
            .foregroundColor(.black)
            .padding()
            
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
//                Button {
//
//                } label: {
//                    Image(systemName: "arrow.uturn.backward")
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(.white)
//                        .shadow(radius: 5)
//                        .padding(13)
//                        .background(Color.gray)
//                        .clipShape(Circle())
//                }

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

//                Button {
//
//                } label: {
//                    Image(systemName: "star.fill")
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(.white)
//                        .shadow(radius: 5)
//                        .padding(13)
//                        .background(Color.yellow)
//                        .clipShape(Circle())
//                }

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
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.75, alignment: .top)
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
