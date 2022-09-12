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
    @FocusState private var searchFocused: Bool
    
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
            }
            
            VStack (spacing: 0) {
                HStack (spacing: 20) {
                    Button {
                        navigationHelper.selection = nil
                    } label: {
                        BackNavigateButton()
                    }
                    HStack {
                        TextField("Find Venue...", text: $mapViewModel.searchText)
                            .foregroundColor(Color.theme.textColor)
                            .font(.system(size: 18))
                            .focused($searchFocused)
                        if mapViewModel.searchText != "" {
                            Button {
                                withAnimation() {
                                    mapViewModel.filteredVenue = []
                                    mapViewModel.searchText = ""
                                    searchFocused = false
                                }
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(Color.theme.textColor)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.theme.popupColor)
                            .frame(width: 310, height: 40)
                            .shadow(radius: 5)
                    )
                    
                    
                }
                .padding(.trailing, 20)
                .padding(.top, 40)
                .padding(.leading, 20)
                
                if let filterVenue = mapViewModel.filteredVenue, !filterVenue.isEmpty {
                    List {
                        ForEach(filterVenue) {venue in
                            HStack {
                                Button {
                                    withAnimation {
                                        mapViewModel.filteredVenue = []
                                        mapViewModel.searchText = ""
                                        searchFocused = false
                                        mapViewModel.showVenuePreview(venue: venue)
                                    }
                                } label: {
                                    Text(venue.name)
                                        .foregroundColor(Color.theme.textColor)
                                }
                            }
                        }.listRowBackground(Color.theme.popupColor)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                    .listStyle(.plain)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
                    )
                }
                
                if mapViewModel.isPreviewShow {
                    VenueDetailView(venue: mapViewModel.selectedVenue!, isPreviewShow: $mapViewModel.isPreviewShow)
                        .shadow(radius: 5)
                        .padding(.top, 10)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
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
