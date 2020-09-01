//
//  MapManager.swift
//  TrackEnsure Test Task
//
//  Created by Roman Oliinyk on 29.08.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
    
    private let locationManager = CLLocationManager()
    private let distance = 1000.0
    
    private var placeCoordinate: CLLocationCoordinate2D?
    
    //    Setup the placemark of GasStation
    func setupPlacemark(gasStation: GasStation?, mapView: MKMapView) {
        guard let location = gasStation?.address else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = gasStation?.name
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
     func setupPlacemark(location: CLLocation, mapView: MKMapView) {
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location.coordinate
        self.placeCoordinate = location.coordinate
        
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    
    //    Focus map on user location
    func showUserLocation(mapView: MKMapView) {
        guard let location = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
    //    Defines the center of the map
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //    Check if location services are available
    func checkLocationServices(mapView: MKMapView, closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView)
            closure()
        } else {
            self.showAlert(title: "Location services are diabled", message: "Enable it in settings")
        }
    }
    
    //    Check an app authorization before using location services
    func checkLocationAuthorization(mapView: MKMapView) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse :
            mapView.showsUserLocation = true
            break
        case .authorizedAlways :
            break
        case .denied :
            showAlert(title: "You denied access to the location", message: "Please change it in the settings")
            break
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted :
            showAlert(title: "You denied access to the location", message: "Please change it in the settings")
            break
        @unknown default:
            print("new case is available")
        }
    }
    
    func addressOnTap(tapOnMap: UITapGestureRecognizer, mapView: MKMapView) -> CLLocation {
        let location = tapOnMap.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        let clLocation = CLLocation(latitude: latitude, longitude: longitude)
        return clLocation
    }
    
    // Show location by tap
    
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(okAction)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(ac, animated: true)
    }
}
