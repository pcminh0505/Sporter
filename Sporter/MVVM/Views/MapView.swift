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
    @EnvironmentObject var navigationHelper: NavigationHelper
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            ZStack (alignment: .bottom) {
                Map(coordinateRegion: $mapViewModel.mapRegion,
                    showsUserLocation: true,
                    annotationItems: mapViewModel.venues,
                    annotationContent: {venue in
                        MapAnnotation (coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude)!,
                                                                         longitude: Double(venue.longitude)!)) {
                            CustomMapAnnotationView(name: venue.name)
                                .scaleEffect(venue == mapViewModel.selectedVenue && mapViewModel.isPreviewShow ? 1.2 : 1)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    mapViewModel.showVenuePreview(venue: venue)
                                }
                        }
                })
                    .accentColor(Color(.systemPink))
                    .onAppear {
                        mapViewModel.checkLocationServiceEnabled()
                    }
                
                VStack (alignment: .trailing, spacing: 0) {
                    // focus on current location
//                    LocationButton(.currentLocation) { mapViewModel.requestLocationPermission() }
//                        .symbolVariant(.fill)
//                        .labelStyle(.iconOnly)
//                        .foregroundColor(.white)
//                        .cornerRadius(6)
//                        .tint(.red) // color
//                        .padding(.trailing)
//                        .padding(.top, 40)
//                        .padding(.bottom, 10)
                    
                    // show/hide venue preview
                    if mapViewModel.isPreviewShow {
                        VenueDetailView(venue: mapViewModel.selectedVenue!, isPreviewShow: $mapViewModel.isPreviewShow)
                            .shadow(radius: 5)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)))
                    }
                }
            }
            
            VStack {
                HStack {
                    Button {
                        navigationHelper.selection = nil
                    } label: {
                        BackNavigateButton()
                    }
                    
                    TextField("Find Venue...", text: $mapViewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(Color.theme.red)
                        .font(.system(size: 18))
                }
                .padding(.trailing, 65)
                .padding(.top, 40)
                .padding(.leading, 20)
                
                if let filterVenue = mapViewModel.filteredVenue, !filterVenue.isEmpty {
                    List {
                        ForEach(filterVenue) {venue in
                            HStack {
                                Text(venue.name)
                                    .foregroundColor(Color.theme.red)
                                    .onTapGesture {
                                        mapViewModel.filteredVenue = []
                                        mapViewModel.searchText = ""
                                        mapViewModel.showVenuePreview(venue: venue)
                                    }
                                
                                
                            }
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
