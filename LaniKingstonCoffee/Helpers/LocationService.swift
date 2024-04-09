//
//  LocationManager.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/18/23.
//

import UIKit
import CoreLocation

protocol MapUpdateProtocol: AnyObject {
    func mapUpdate(locations: [CLLocation])
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    // Stored Properties
    var locationManager: CLLocationManager
    var currentLocation: CLLocation?
    weak var delegate: MapUpdateProtocol?
    
    init(locationManager: CLLocationManager = CLLocationManager(), currentLocation: CLLocation? = nil) {
        self.locationManager = locationManager
        self.currentLocation = currentLocation
        super.init()
//        setup()
    }
    
    func setup() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        delegate?.mapUpdate(locations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      // Check accuracy authorization
      let accuracy = manager.accuracyAuthorization
      switch accuracy {
      case .fullAccuracy:
          print("Location accuracy is precise.")
      case .reducedAccuracy:
          print("Location accuracy is not precise.")
      @unknown default:
        fatalError()
      }

      // Handle authorization status
      switch status {
      case .restricted:
        print("Location access was restricted.")
      case .denied:
        print("User denied access to location.")
        // Display the map using the default location.
//        mapView.isHidden = false
      case .notDetermined:
        print("Location status not determined.")
      case .authorizedAlways: fallthrough
      case .authorizedWhenInUse:
        print("Location status is OK.")
      @unknown default:
        fatalError()
      }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      locationManager.stopUpdatingLocation()
      print("LocationManager didFailWithError: \(error)")
    }
    
}
