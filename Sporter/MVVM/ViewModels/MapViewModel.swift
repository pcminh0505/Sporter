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

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.7770833, longitude: 106.6932374),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
    @Published var isPreviewShow = false
    @Published var selectedVenue : Venue?
    
    var locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastestLocation = locations.first else { return }
        DispatchQueue.main.async {
            self.mapRegion = MKCoordinateRegion(center: lastestLocation.coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012))
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
}
