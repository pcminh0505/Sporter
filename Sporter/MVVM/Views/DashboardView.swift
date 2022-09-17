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
    @State private var leaveAlert: Bool = false
    @State private var selectedEvent: EventData?
    @State private var isPopupShow: Bool = false
    @State private var blurAmount = 0
    @StateObject var notiVM = NotificationViewModel()

    let user: User

    var body: some View {
        ZStack {
            VStack {
                // Navigation links (no hidden UI)
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

                // Avatar bar
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
                    .padding()

                Divider()

                // Header: Upcoming Events + Go to Map
                HStack {
                    Text("Upcoming Events")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                    Spacer()
                    Button {
                        navigationHelper.selection = "map"
                    } label: {
                        HStack {
                            Text("Go to Map")
                            Image(systemName: "map.fill")
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                }
                    .padding(.horizontal)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    // Display if event list is empty
                    if dashboardViewModel.events.isEmpty {
                        Text("You are not joining any events.")
                            .padding()
                    } else {
                        // Personal events list
                        UserEventList
                    }
                }
            }
                .allowsHitTesting(!isPopupShow)
                .blur(radius: CGFloat(blurAmount))
                .padding(.bottom, -25) // Fix weird white space at the bottom

            // Pop-up UI
            if isPopupShow {
                EventDetailPopup
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(user: User.unset)
            .environmentObject(NavigationHelper())
    }
}

extension DashboardView {
    // Alert popup when user wants to delete an event
    private var DeleteEventAlertPopup: Alert {
        Alert (
            title: Text("Do you want to delete this event?"),
            message: Text("This action can't undone"),
            primaryButton: .destructive(Text("Delete")) {
                withAnimation {
                    if let event = selectedEvent?.event {
                        dashboardViewModel.deleteEvent(event.id ?? "0")
                    }
                }
            },
            secondaryButton: .cancel()
        )
    }
    // Alert popup when user wants to withdraw from an event
    private var LeaveEventAlertPopup: Alert {
        Alert (
            title: Text("Do you want to leave this event?"),
            message: Text("You can rejoin the event in map"),
            primaryButton: .destructive(Text("Leave")) {
                withAnimation {
                    if let event = selectedEvent?.event {
                        dashboardViewModel.leaveEvent(event.id ?? "0")
                    }
                }
            },
            secondaryButton: .cancel()
        )
    }
    // Show list of events that current user participates in
    private var UserEventList : some View {
        ScrollView {
            VStack {
                ForEach(dashboardViewModel.events, id: \.id) { data in
                    // Individual event card (tap to show pop-up)
                    VStack {
                        // Venue name and join status
                        HStack (alignment: .top) {
                            if data.event.isPrivate == true {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.accentColor)
                            }
                            Text(data.event.title)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                                .lineLimit(2)

                            Spacer()

                            // Delete / Leave button
                            if let eventID = data.event.id {
                                // If user is the event creator, can delete the event
                                if (dashboardViewModel.isEventCreator[eventID] ?? false) {
                                    Button {
                                        selectedEvent = data
                                        deleteAlert = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "trash.fill")
                                            Text("Delete")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                        }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.accentColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                        .alert(isPresented: $deleteAlert) { DeleteEventAlertPopup }
                                // If user is not the event creator, can leave the event
                                } else {
                                    Button {
                                        selectedEvent = data
                                        leaveAlert = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "xmark.square.fill")
                                            Text("Leave")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                        }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.accentColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                        .alert(isPresented: $leaveAlert) { LeaveEventAlertPopup }
                                }
                            }
                        }
                            .padding(.horizontal)
                            .padding(.top)

                        // Event information
                        VStack (alignment: .leading, spacing: 5) {
                            Text(data.event.description)
                                .lineLimit(1)

                            HStack {
                                Text("Creator:").fontWeight(.bold)
                                Text("\(data.creator.fname) \(data.creator.lname)")
                                Spacer()
                            }

                            HStack {
                                Image(systemName: "clock.fill")
                                Text(dashboardViewModel.timeConversion(data.event.startTime))
                                Text("-")
                                Text(dashboardViewModel.timeConversion(data.event.endTime))
                            }
                        }
                            .font(.system(size: 15))
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                    }
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 2))
                        .padding(.bottom, 5)
                        .onTapGesture {
                        withAnimation {
                            selectedEvent = data
                            blurAmount = 5
                            isPopupShow = true
                        }
                    }
                }
                Spacer()
            }
                .padding()
        }
    }
    // Popup detail view when user taps on an event from the list
    private var EventDetailPopup : some View {
        VStack (alignment: .leading) {
            HStack {
                Spacer()
                Text("Event Detail")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.accentColor)
                Spacer()
            }
                .padding()
            // Event detail infomation
            if let event = selectedEvent?.event, let venue = selectedEvent?.venue, let user = selectedEvent?.creator {
                VStack (alignment: .leading, spacing: 10) {
                    Text("**Title:** \(event.title)")
                    Text("**Description:** \(event.description)")
                    Text("**From:** \(dashboardViewModel.timeConversion(event.startTime))")
                    Text("**To:** \(dashboardViewModel.timeConversion(event.endTime))")
                    Text("**Venue:** \(venue.name)")
                    Text("**Address:** \(venue.address)")
                    Text("**Creator:** \(user.fname) \(user.lname)")
                    Text("**No. participants:** \(event.participants.count)")

                    HStack {
                        Spacer()
                        if event.isPrivate {
                            Text("Private Event - available to friends and family")
                                .font(.subheadline)
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.theme.darkGray)
                        } else {
                            Text("Public Event - available to everyone")
                                .font(.subheadline)
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.theme.darkGray)
                        }
                        Spacer()
                    }
                        .padding(.top)
                }
                    .padding()
            }
            Spacer()
            
            // Close button
            HStack {
                Spacer()
                Button {
                    self.isPopupShow = false
                    self.blurAmount = 0
                } label: {
                    Text("Close")
                }
                    .padding()
                    .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8,
               height: UIScreen.main.bounds.height * 0.6)
        .background(
            RoundedRectangle(cornerRadius: 10)
            .fill(Color.theme.popupColor)
            .shadow(radius: 10))
    }
}
