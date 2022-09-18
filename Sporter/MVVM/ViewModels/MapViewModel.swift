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
//        locationManager.delegate = self
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
    func checkLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("Location service disabled")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Location restricted, due to parental control")
            case .denied:
                print("Location denied, set in setting")
            case .authorizedAlways, .authorizedWhenInUse:
                if let location = locationManager.location {
                    mapRegion = MKCoordinateRegion(center: location.coordinate,
                                                   span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
                }
                
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         checkLocationAuthorization()
    }
    
//    // Location Manager follow device location
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let lastestLocation = locations.first else { return }
//        DispatchQueue.main.async {
//            self.mapRegion = MKCoordinateRegion(center: lastestLocation.coordinate,
//                                                span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
//        }
//    }
//    // If location service fails
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription )
//    }
//    // Request for location permission when user first opens map view
//    func requestAllowOnceLocationPermission() {
//        locationManager.requestLocation()
//    }
    
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
