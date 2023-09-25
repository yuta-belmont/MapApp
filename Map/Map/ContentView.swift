//
//  ContentView.swift
//  Map
//
//  Created by Yuta Belmont on 9/24/23.
//
import MapKit
import SwiftUI
import CoreLocation


struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .onAppear{
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
}

final class ContentViewModel: NSObject, ObservableObject,
CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center:
                                                CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417),
                                              span: MKCoordinateSpan (latitudeDelta: 1,
                                                                      longitudeDelta: 1))
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("We're fucked")
        }
        
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Authorization restricted")
            case .denied:
                print("Authorization denied")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 50.785834, longitude: -122.406417),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

// Comment test
// Ur wildin
