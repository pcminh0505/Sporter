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
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
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
                                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription )
    }
    
//    func checkLocationServiceEnabled() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager!.delegate = self
//        } else {
//            print("Show alert: location service not enabled")
//        }
//    }
//
//    private func checkLocationPermissionEnabled() {
//        guard let locationManager = locationManager else { return }
//
//        switch locationManager.authorizationStatus {
//            case .notDetermined:
//                locationManager.requestWhenInUseAuthorization()
//            case .restricted:
//                print("Your location is restricted, likely due to parental controls.")
//            case .denied:
//                print("Denied location permission, check in setting.")
//            case .authorizedAlways, .authorizedWhenInUse:
//                mapRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,
//                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//            @unknown default:
//                break
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationPermissionEnabled()
//    }
}
