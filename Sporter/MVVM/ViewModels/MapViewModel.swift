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
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.7770833, longitude: 106.6932374),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
    
    @Published var isPreviewShow = false
    @Published var selectedVenue : Venue?
    @Published var venueRepository =  VenueRepository()
    @Published var venues: [Venue] = []
    private var cancellables: Set<AnyCancellable> = []
    @Published var filteredVenue: [Venue]?
    
    @Published var searchText: String = ""
    var searchTextCancellables: AnyCancellable?
    @State var currentCoordinates: CLLocationCoordinate2D? = nil
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
//        locationManager.delegate = self
        venueRepository.$venues
            .assign(to: \.venues, on: self)
            .store(in: &cancellables)

        searchTextCancellables = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.filterVenue(value: value)
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
                mapRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                               span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         checkLocationAuthorization()
    }

//    func requestLocationPermission() {
//        locationManager.requestLocation()
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastestLocation = locations.first else { return }
        DispatchQueue.main.async {
            self.mapRegion = MKCoordinateRegion(center: lastestLocation.coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
            self.currentCoordinates = lastestLocation.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription )
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
