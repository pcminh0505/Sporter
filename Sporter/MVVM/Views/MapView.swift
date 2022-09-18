/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 30/08/2022
    Last modified: 18/09/2022
*/

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct MapView: View {
    @EnvironmentObject var navigationHelper: NavigationHelper
    @EnvironmentObject var eventRepository: EventRespository
    @StateObject private var mapViewModel = MapViewModel()
    @FocusState private var searchFocused: Bool
        
    var body: some View {
        ZStack (alignment: .topLeading) {
            ZStack (alignment: .bottom) {
                // Map with custom annotations for gym venues
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
                HStack (spacing: 10) {
                    // Navigate back button
                    Button {
                        navigationHelper.selection = nil
                    } label: {
                        BackNavigateButton()
                    }
                    // Search bar
                    HStack {
                        TextField("Find venue...", text: $mapViewModel.searchText)
                            .foregroundColor(Color.theme.textColor)
                            .font(.system(size: 18))
                            .focused($searchFocused)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                }
                .padding(.trailing, 20)
                .padding(.top, 40)
                .padding(.leading, 20)
                // Search results list
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
                                        .transition(.opacity)
                                }
                            }
                        }.listRowBackground(Color.theme.popupColor)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8,
                           maxHeight: UIScreen.main.bounds.height * 0.5)
                    .listStyle(.plain)
                }
                // Show venue detail on tap
                if mapViewModel.isPreviewShow {
                    if let selectedVenue = mapViewModel.selectedVenue {
                        
                        if let selectedVenueDetailVM = mapViewModel.venueDetailVMs.first(where: { $0.id == selectedVenue.id}) {
                            
                            VenueDetailView(venue: mapViewModel.selectedVenue!,
                                            isPreviewShow: $mapViewModel.isPreviewShow,
                                            venueDetailViewModel: selectedVenueDetailVM)
                                .shadow(radius: 5)
                                .padding(.top, 10)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
                            
                        }
                    }
                    
                }
            }
            if mapViewModel.alert {
                ErrorView (alert: $mapViewModel.alert, error: $mapViewModel.error)
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
