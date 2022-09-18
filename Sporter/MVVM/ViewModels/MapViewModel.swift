//
//  MapViewModel.swift
//  Sporter
//
//  Created by Khang on 06/09/2022.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI
import Combine

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let venueRepository =  VenueRepository()
    @StateObject var userRepository = UserRepository()
    // Default map center location
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.7770833, longitude: 106.6932374),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
    @Published var alert = false
    @Published var error = ""
    
    @Published var isPreviewShow = false
    @Published var selectedVenue : Venue?
    @Published var venues: [Venue] = []
    @Published var venueDetailVMs: [VenueDetailViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    @Published var filteredVenue: [Venue]? = []
    @Published var searchText: String = ""
    var searchTextCancellables: AnyCancellable?
    var locationManager : CLLocationManager?
    
    override init() {
        super.init()
        // Get list of venues
        venueRepository.$venues
            .assign(to: \.venues, on: self)
            .store(in: &cancellables)
        // Create list of Venue Detail VM with list of venue
        venueRepository.$venues
            .map{ venues in
                venues.map(VenueDetailViewModel.init)
            }
            .assign(to: \.venueDetailVMs, on: self)
            .store(in: &cancellables)
        // Handling search text from user
        searchTextCancellables = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                withAnimation() {
                    self.filterVenue(value: value)
                    if self.filteredVenue != [] {
                        self.isPreviewShow = false
                    }
                }
        })
    }
    // Check location service enabled, if yes: create location manager; if not: show alert
    func checkLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            self.error = "Location service is disabled, please turn on location service"
            self.alert.toggle()
        }
    }
    // When user first open map, request for location permission
    // If any error occured, or if user deny to allow permission, show corresponding alert
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                self.error = "Location restricted, likely due to parental control"
                self.alert.toggle()
            case .denied:
                self.error = "Location denied, please turn on location permission in settings"
                self.alert.toggle()
            case .authorizedAlways, .authorizedWhenInUse:
                if let location = locationManager.location {
                    mapRegion = MKCoordinateRegion(center: location.coordinate,
                                                   span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
                }
                
            @unknown default:
                break
        }
    }
    // If location manager detects changes in authorization, recall function
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         checkLocationAuthorization()
    }
    
    // show venue preview
    func showVenuePreview(venue: Venue) {
        withAnimation {
            selectedVenue = venue
            let focusCoordinate = CLLocationCoordinate2D(latitude: Double(venue.latitude)!,
                                                    longitude: Double(venue.longitude)!)
            self.mapRegion = MKCoordinateRegion(center: focusCoordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
            isPreviewShow = true
        }
    }
    
    // return filtered result for search bar
    func filterVenue(value: String) {
        if value.isEmpty {
            filteredVenue = []
        } else {
            filteredVenue = venues.filter {
                $0.name
                    .localizedCaseInsensitiveContains(value)
            }
        }
    }
}
