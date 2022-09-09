//
//  MapVenuePreviewView.swift
//  Sporter
//
//  Created by Khang on 07/09/2022.
//

import Foundation
import SwiftUI
import MapKit

struct VenuePreviewView : View {
    let venue: Venue
    @Binding var isPreviewShow: Bool
    @State var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.45
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    @State private var isRotated = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack (spacing: 10) {
            VStack {
                HStack {
                    Image(systemName: "chevron.up")
                        .rotationEffect(Angle.degrees(isRotated ? 180 : 0))
                        .onTapGesture {
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
                        }
                    
                    Image(systemName: "xmark")
                        .onTapGesture {
                            withAnimation() {
                                isPreviewShow.toggle()
                            }
                        }
                }
                
                venuePreviewText
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                Text("Open time: " + venue.open_time)
                Text("Close time: " + venue.close_time)
                Text("Phone Number: " + venue.phone)
                HStack {
                    Text("Website:")
                    Link("Click here", destination: URL(string: venue.website)!)
                }
                Text("Ratings: " + venue.rating)
                
                venuePreviewImage
                
                Text("Events")
                    .padding(.top, 10)
                Text("current events")
            }
            .padding()
        }
        .background(Color(colorScheme == .dark ? .black : .white))
        .frame(maxWidth: .infinity)
        .cornerRadius(30)
        .ignoresSafeArea()
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
                .onEnded {value in
                    withAnimation(.spring()) {
                        if currentDragOffsetY < -UIScreen.main.bounds.height * 0.3 {
                            endingOffsetY = -startingOffsetY
                            currentDragOffsetY = 0
                            isRotated.toggle()
                        } else if currentDragOffsetY > UIScreen.main.bounds.height * 0.3 && endingOffsetY != 0 {
                            endingOffsetY = 0
                            currentDragOffsetY = 0
                            isRotated.toggle()
                        }
                    }
                }
        )
    }
}

extension VenuePreviewView {
    private var venuePreviewImage : some View {
        AsyncImage (
            url: URL(string: venue.img),
            content: { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(maxHeight: 150)
//                     .scaledToFit()
            },
            placeholder: {
                ProgressView()
            }
        )
    }
    
    private var venuePreviewText : some View {
        ZStack(alignment: .topTrailing) {
            VStack (alignment: .leading, spacing: 5) {
                Text(venue.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Text(venue.address)
                    .font(.system(size: 15))
                    
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
