//
//  DashboardView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    @EnvironmentObject var navigationHelper: NavigationHelper
    @EnvironmentObject var notiVM: NotificationViewModel
    @StateObject var dashboardViewModel = DashboardViewModel()
//    @State private var deleteAlert : Bool = false
//    @State private var withdrawAlert : Bool = false
    
    let user: User

    var body: some View {
        VStack {
            NavigationLink(tag: "map", selection: $navigationHelper.selection) {
                MapView()
                    .navigationBarHidden(true)
            } label: {
                EmptyView()
            }.isDetailLink(false)
            
            NavigationLink(tag: "request", selection: $navigationHelper.selection) {
                NotificationView()
                    .environmentObject(notiVM)
                    .navigationBarHidden(true)
            } label: {
                EmptyView()
            }.isDetailLink(false)

            HStack(spacing: 10) {
                AsyncImage (
                    url: URL(string: user.profileImage),
                    content: { image in
                        image.resizable()
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(25)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    },
                    placeholder: {
                        ProgressView()
                            .cornerRadius(25)
                            .frame(width: 50, height: 50)
                            .background(Color(uiColor: .systemGray6))
                            .clipShape(Circle())
                    }
                )
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.theme.textColor))

                VStack (alignment: .leading) {
                    Text("Welcome")
                        .font(.body)
                    Text("\(user.fname) \(user.lname)")
                        .font(.title2)
                        .fontWeight(.bold)
                }

                    .foregroundColor(Color.theme.textColor)

                Spacer()

                Button {
                    navigationHelper.selection = "request"
                } label: {
                    SquareButton(imgName: "bell.fill")
                }
            }

            Button {
                navigationHelper.selection = "map"
            } label: {
                HStack {
                    Text("Go to Map")
                    Image(systemName: "map.fill")
                }
                    .padding(.vertical)
                    .foregroundColor(.white)
            }
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.top, 25)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(dashboardViewModel.events, id:\.id) {data in
                        HStack (alignment: .center) {
                            VStack {
                                Text(data.event.title)
                                Text(data.event.description)
                                
                                HStack {
                                    Text("Creator:")
                                        .fontWeight(.bold)
                                    Text("\(data.creator.fname) \(data.creator.lname)")
                                }
                                
                                HStack {
                                    Text("Venue:")
                                        .fontWeight(.bold)
                                    Text(data.venue.name)
                                }
                                HStack {
                                    Text(data.venue.address)
                                }
                            }
                            .padding()
                            
                            Spacer()
                            
                            if let eventID = data.event.id {
                                if (dashboardViewModel.isEventCreator[eventID] ?? false ) {
                                    Button {
                                        withAnimation {
                                            dashboardViewModel.deleteEvent(eventID)
                                        }
                                    } label: {
                                        Text("Delete Event")
                                    }
                                } else {
                                    Button {
                                        withAnimation {
                                            dashboardViewModel.withdrawEvent(eventID)
                                        }
                                    } label: {
                                        Text("Withdraw Event")
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(user: User.unset)
            .environmentObject(NavigationHelper())
    }
}
