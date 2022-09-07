//
//  MapView.swift
//  Sporter
//
//  Created by Minh Pham on 31/08/2022.
//
import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct MapView: View {
    @EnvironmentObject private var venueViewModel : VenueViewModel
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $mapViewModel.mapRegion,
                showsUserLocation: true,
                annotationItems: venueViewModel.venues,
                annotationContent: {venue in
                    MapAnnotation (coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude)!,
                                                                     longitude: Double(venue.longitude)!)) {
                        CustomMapAnnotationView(name: venue.name)
                            .shadow(radius: 5)
                            .onTapGesture {
                                mapViewModel.showVenuePreview(venue: venue)
                            }
                    }
            })
                .ignoresSafeArea()
                .accentColor(Color(.systemPink))
            
            VStack (alignment: .trailing, spacing: 0) {
                // focus on current location
                LocationButton(.currentLocation) { mapViewModel.requestLocationPermission() }
                    .symbolVariant(.fill)
                    .labelStyle(.iconOnly)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .tint(.red) // color
                    .padding()
                // show/hide venue preview
                if mapViewModel.isPreviewShow {
                    VenuePreviewView(venue: mapViewModel.selectedVenue!)
                        .shadow(radius: 5)
                        .padding(10)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(VenueViewModel())
    }
}
