//
//  MapViewController.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/6/23.
//

import CoreLocation
import MapKit
import GooglePlaces
import GoogleMaps
import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapLoadingSpinner: UIActivityIndicatorView!
    var segueComplete = false
    var locationService: LocationService? {
        didSet {
            self.mapSetup()
        }
    }
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 12.0
    var approximateLocationZoomLevel: Float = 10.0
    var mapCafes: [Cafe] = []
    
    override func viewDidLoad() {
        mapLoadingSpinner.backgroundColor = UIColor(named: "Main")
        mapLoadingSpinner.startAnimating()
        
        let queue = DispatchQueue(label: "MapView Q")
        queue.async {
            while !self.segueComplete {
//                self.view.backgroundColor = .green
//                UIView.backgroundColor must be used from main thread only
//                UIViewController.view must be used from main thread only
            }
            DispatchQueue.main.async {
                for obj in self.mapCafes {
                    self.makeAnnotation(cafeObj: obj)
                    self.mapView.delegate = self
                }
                self.mapLoadingSpinner.isHidden = true
                self.mapLoadingSpinner.stopAnimating()
            }
        }
        
        super.viewDidLoad()
        
    } //END ViewDidLoad
    
    
    func mapSetup() {
        guard let locationService = locationService else { return }
        locationService.delegate = self
        locationService.setup()
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        // Create a map.
        
        let zoomLevel = locationService.locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        
//        mapView.isHidden = true
    }
    
//    Swift Work Order - Running functions in order with Swift
    
    func makeAnnotation(cafeObj: Cafe) {
        let marker = GMSMarker()
            if ((cafeObj.googlePlace?.coordinate) != nil) {
                marker.position = (cafeObj.googlePlace?.coordinate)!
                marker.title = cafeObj.name
                marker.snippet = cafeObj.googlePlace?.isOpen
                marker.icon = GMSMarker.markerImage(with: .cyan)
                marker.userData = cafeObj
                
                marker.map = self.mapView
            } else {
                print("THIS ONE IS EMPTY COORDINATE 👀👀👀👀👀👀👀👀👀 \(cafeObj)")
            }
        }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "fromMapToCafeDetailView", sender: marker.userData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMapToCafeDetailView" {
            let destination = segue.destination as! CafeDetailViewController
            destination.cafe = sender as? Cafe
        }
    }
    
    
} // END MapViewController


    

// Delegates to handle events for the location manager.
extension MapViewController: MapUpdateProtocol {
    func mapUpdate(locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")

        guard let locationService = locationService else { return }
          
        let zoomLevel = locationService.locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoomLevel
        )
        if mapView.isHidden {
          mapView.isHidden = false
          mapView.camera = camera
        } else {
          mapView.animate(to: camera)
        }
    }

}
    

