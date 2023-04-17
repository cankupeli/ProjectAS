//
//  mapViewModel.swift
//  ProjectAS
//
//  Created by Can Kupeli on 2023-04-12.
//

import Foundation
import SwiftUI
import MapKit

final class mapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    var locationManager: CLLocationManager?
    @Published var region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 62.3908,
                    longitude: 17.3069),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.09,
                    longitudeDelta: 0.04)
                )
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
        else{
            print("we dont have GPS access because users location services is not enabled")
        }
    }
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("we dont have GPS access because users location is restricted - change parental restriction")
        case .denied:
            print("we dont have GPS access because users has denied it - change in app setting")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.09,
                    longitudeDelta: 0.04)
                )
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
