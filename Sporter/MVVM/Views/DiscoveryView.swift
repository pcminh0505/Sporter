/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Long Tran
    ID: s3755615
    Created date: 04/09/2022
    Last modified: 18/09/2022
*/


import Foundation
import SwiftUI

struct DiscoveryView: View {
    @StateObject var discoveryVM = DiscoveryViewModel()

    var body: some View {
        VStack {
            // Users Stack
            ZStack {
                if let users = discoveryVM.displayingUsers {
                    if users.isEmpty {
                        Text("Come back later, we can find more matches for you")
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
                .padding(.horizontal)
                .padding(.top, 40)
                .padding(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Action Buttons
            HStack (alignment: .center) {
                // Swipe left indicator
                Image(systemName: "arrow.backward")
                    .font(.system(size: 25, weight: .black))
                    .foregroundColor(Color.blue)
                    .shadow(radius: 5)

                // Swipe left
                Button {
                    doSwipe()
                } label: {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 25, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                    .padding(10)

                // Swipe right
                Button {
                    doSwipe(rightSwipe: true)
                } label: {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 25, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                    .padding(10)

                // Swipe right indicator
                Image(systemName: "arrow.right")
                    .font(.system(size: 25, weight: .black))
                    .foregroundColor(Color.accentColor)
                    .shadow(radius: 5)

            }
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
