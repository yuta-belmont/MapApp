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
                viewModel.checkIfLoactionServicesIsEnabled()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel: NSObject, ObservableObject,
CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center:
                                                CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                              span: MKCoordinateSpan (latitudeDelta: 1,
                                                                      longitudeDelta: 1))
    
    func checkIfLoactionServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("We're fucked")
        }
        
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Authorization restricted")
            break
        case .denied:
            print("Authorization denied")
            break
        case .authorizedAlways:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

// Comment test
