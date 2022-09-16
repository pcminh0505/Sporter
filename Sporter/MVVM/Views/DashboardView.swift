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
    @StateObject var dashboardViewModel = DashboardViewModel()
    @State private var deleteAlert: Bool = false
    @State private var withdrawAlert: Bool = false
    @State private var selectedEventId: String = ""
    @State private var isPopupShow: Bool = false
    @State private var blurAmount = 0
    @StateObject var notiVM = NotificationViewModel()

    let user: User

    var body: some View {
        ZStack (alignment: .center) {
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

            Text("Upcoming Events")
                .font(.title3)
                .foregroundColor(Color.accentColor)
                .fontWeight(.bold)

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(dashboardViewModel.events, id: \.id) { data in
                        VStack (alignment: .leading) {
                            VStack (alignment: .leading) {
                                HStack (spacing: 5) {
                                    Text(data.event.title)
                                        .font(.headline)
                                        .fontWeight(.bold)

                                    Spacer()

                                    if data.event.isPrivate == true {
                                        Text("Private event")
                                            .font(.body)
                                            .foregroundColor(Color.theme.darkGray)
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(Color.theme.darkGray)
                                    } else {
                                        Text("Public event")
                                            .font(.body)
                                            .foregroundColor(Color.theme.darkGray)
                                        Image(systemName: "lock.open.fill")
                                            .foregroundColor(Color.theme.darkGray)
                                    }
                                }


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

                            }
                                .padding(.top)
                                .padding(.horizontal)

                            HStack {
                                Spacer()

                                if let eventID = data.event.id {
                                    if (dashboardViewModel.isEventCreator[eventID] ?? false) {
                                        Button {
                                            selectedEventId = eventID
                                            deleteAlert = true
                                        } label: {
                                            Text("Delete")
                                        }
                                            .padding(.bottom)
                                            .padding(.horizontal)
                                            .buttonStyle(.borderedProminent)
                                            .alert (isPresented: $deleteAlert) { DeleteAlertPopup }
                                    } else {
                                        Button {
                                            selectedEventId = eventID
                                            withdrawAlert = true
                                        } label: {
                                            Text("Withdraw")
                                        }
                                            .buttonStyle(.borderedProminent)
                                            .padding(.bottom)
                                            .padding(.horizontal)
                                            .alert(isPresented: $withdrawAlert) { WithdrawAlertPopup }
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

extension DashboardView {
    private var DeleteAlertPopup: Alert {
        Alert (
            title: Text("Do you want to delete this event?"),
            message: Text("This action can't undone"),
            primaryButton: .destructive(Text("Delete")) {
                withAnimation {
                    dashboardViewModel.deleteEvent(selectedEventId)
                }
            },
            secondaryButton: .cancel()
        )
    }

    private var WithdrawAlertPopup: Alert {
        Alert (
            title: Text("Do you want to withdraw from this event?"),
            message: Text("You can rejoin the event in map"),
            primaryButton: .destructive(Text("Withdraw")) {
                withAnimation {
                    dashboardViewModel.withdrawEvent(selectedEventId)
                }
            },
            secondaryButton: .cancel()
        )
    }
}
