//
//  MapVenuePreviewView.swift
//  Sporter
//
//  Created by Khang on 07/09/2022.
//

import Foundation
import SwiftUI
import MapKit

struct VenueDetailView : View {
    @EnvironmentObject var navigationHelper: NavigationHelper

    let venue: Venue
    @Binding var isPreviewShow: Bool
    @State var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.735
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    @State private var isRotated = false
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 10) {
            // Navigation to New Event Form
            NavigationLink(tag: "new-event", selection: $navigationHelper.selection) {
                NewEventForm(venue: venue)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                EmptyView()
            }
            .isDetailLink(false)

            header
                .padding(.top, 10)
                .padding(.horizontal)
            venuePreviewText
                .padding(.horizontal)
                .padding(.bottom, 30)

            ScrollView(.vertical) {
                VStack (alignment: .leading) {
                    venueDetailText
                    
                    VStack (alignment: .center, spacing: 10) {
                        venuePreviewImage
                        
                        Button {
                            navigationHelper.selection = "new-event"
                        } label: {
                            HStack {
                                Text("New Event")
                                Image(systemName: "plus.app.fill")
                            }
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        Text("Events")
                            .padding(.top, 10)
                        Text("current events")
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color.theme.popupColor)
        .frame(maxWidth: .infinity)
        .cornerRadius(30)
        .offset(y: startingOffsetY)
        .offset(y: currentDragOffsetY)
        .offset(y: endingOffsetY)
        .gesture (
            DragGesture()
                .onChanged {value in
                    withAnimation(.spring()) {
                        currentDragOffsetY = value.translation.height
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if currentDragOffsetY < -UIScreen.main.bounds.height * 0.2 {
                            endingOffsetY = -startingOffsetY
                            isRotated.toggle()
                        } else if currentDragOffsetY > UIScreen.main.bounds.height * 0.2 && endingOffsetY != 0 {
                            endingOffsetY = 0
                            isRotated.toggle()
                        }
                        currentDragOffsetY = 0
                    }
                }
        )
    }
}

extension VenueDetailView {
    private var venuePreviewImage : some View {
        AsyncImage (
            url: URL(string: venue.img),
            content: { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(maxHeight: 250)
                     .scaledToFit()
            },
            placeholder: {
                ProgressView()
            }
        )
    }
    
    private var venuePreviewText : some View {
        VStack (alignment: .leading, spacing: 5) {
            Text(venue.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.red)

            Text(venue.address)
                .font(.system(size: 15))
        }
    }
    
    private var venueDetailText : some View {
        VStack (alignment: .leading, spacing: 5) {
            HStack {
                Text("Open time:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(venue.open_time + " - " + venue.close_time)
            }
            HStack {
                Text("Phone Number:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(venue.phone)
            }
            
            HStack {
                Text("Ratings:")
                    .font(.headline)
                    .fontWeight(.bold)
                StarRating(rating: Float(venue.rating)!)
                Spacer()
                
                Link(destination: URL(string: venue.website)!) {
                    HStack {
                        Image(systemName: "link")
                        Text("Website")
                            .font(.headline)
                            .fontWeight(.bold)
                    }.foregroundColor(Color.theme.red)
                }
            }
            
        }
    }
    
    private var header : some View {
        HStack {
            Image(systemName: "xmark")
                .foregroundColor(.clear)
            
            Spacer()
            Button {
                withAnimation(.linear) {
                    isRotated.toggle()
                }
                withAnimation(.spring()) {
                    if endingOffsetY == -startingOffsetY {
                        endingOffsetY = 0
                        currentDragOffsetY = 0
                    }
                    else {
                        endingOffsetY = -startingOffsetY
                        currentDragOffsetY = 0
                    }
                }
            } label: {
                Image(systemName: "chevron.up")
                    .rotationEffect(Angle.degrees(isRotated ? 180 : 0))
            }
            Spacer()
            
            Button {
                withAnimation() {
                    isPreviewShow.toggle()
                }
            } label: {
                Image(systemName: "xmark")
            }
        }

    }
}
