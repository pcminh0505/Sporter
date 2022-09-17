//
//  NotificationView.swift
//  Sporter
//
//  Created by Long Tran on 10/09/2022.
//

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
                    // let _ = print(matchRequest)
                    if matchRequest.isEmpty {
                        Text("Come back later, we can find more matches for you")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    else {
                        List(selection: $singleSelection) {
                            ForEach(matchRequest) { user in
                                NotifyCellView(user: user)
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

