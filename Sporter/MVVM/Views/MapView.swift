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
                        CustomMapAnnotationView()
                    }
            })
                .ignoresSafeArea()
                .accentColor(Color(.systemPink))
//                .onAppear {
//                    mapViewModel.checkLocationServiceEnabled()
//                }
            
            LocationButton(.currentLocation) {
                mapViewModel.requestLocationPermission()
            }
            .foregroundColor(.white)
            .cornerRadius(6)
            .tint(.red) // color
            .padding(.bottom)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(VenueViewModel())
    }
}
