//
//  NotificationView.swift
//  Sporter
//
//  Created by Long Tran on 10/09/2022.
//

import Foundation
import SwiftUI

struct NotificationView: View {
    let matchRepo: MatchRepository = MatchRepository()
    let userRepo: UserRepository = UserRepository()
    @StateObject var notiVM = NotificationViewModel()
    @State private var singleSelection: UUID?
    
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
                Text("Notifications")
                    .font(.title.bold())
            )
            .foregroundColor(.black)
            .padding()
            
            ZStack {
                if let matchRequest = notiVM.currentUserMatch
                {
                    let _ = print(matchRequest)
                    if matchRequest.isEmpty {
                        Text("Come back later we can find more matches for you")
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
            .padding(.top, 30)
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            //                List (0...25, id: \.self) {i in
            //                    CellView()
            //                }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.75, alignment: .top)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

