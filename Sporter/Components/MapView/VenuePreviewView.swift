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
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack (alignment: .bottom, spacing: 0) {
                venuePreviewImage
                Spacer()
                venueDetailButton
            }
            venuePreviewText
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .frame(height: 130)
                .offset(y: 65)
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
                     .frame(maxWidth: 150, maxHeight: 150)
                     .cornerRadius(10)
                     .scaledToFit()
            },
            placeholder: {
                ProgressView()
            }
        )
    }
    
    private var venuePreviewText : some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(venue.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(5)
            Text(venue.address)
                .font(.system(size: 15))
        }
    }
    
    private var venueDetailButton : some View {
        Button {
            
        } label: {
            Text("Info & Booking")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .frame(width: 125, height: 30)
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(10)
                .padding()
        }
    }
}
