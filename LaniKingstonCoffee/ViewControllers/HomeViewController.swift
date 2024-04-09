//
//  HomeViewController.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/3/23.
//
import FirebaseFirestore
import GooglePlaces
import CoreLocation
import UIKit

class HomeViewController: UIViewController {
    
    var fetchCompleted = false
    var locationService: LocationService?
    
    @IBOutlet weak var homeSearchBar: UISearchBar!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    enum Segues {
        static let toMapView = "toMapView"
        static let toListView = "toListView"
    }
    
    var cafes: [Cafe] = []
    var filteredCafes: [Cafe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        homeSearchBar.delegate = self
        segmentSetup()
        locationService = LocationService()
        
    } // End ViewDidLoad
    
    override func loadView() {
        fetchFireBase()
        super.loadView()
    }
    
    
    func fetchFireBase() {
        print("🐬🐬🐬🐬🐬🐬🐬🐬🐬🐬🐬🐬🐬🐬")
        //load spinner
        
        CafeController.shared.fetchCafes { result in
            switch result {
            case .success(let cafesFromFireBase):
                self.cafes = cafesFromFireBase
                print("✅✅✅✅✅✅✅✅✅✅✅✅")
                // filter array
                guard let locationService = self.locationService else { return }
                guard let userLocation = locationService.locationManager.location else { return }
                let sortedArray = self.sortCafesBasedOnDistanceFromUserLocation(array: self.cafes, userLocation: userLocation)
                self.cafes = sortedArray
                self.fetchCompleted = true
                
            case .failure(let error):
                print("FetCafes completed with a failure in HomeVC", error.localizedDescription)
                self.fetchCompleted = true
            }
        }
    }
    
    
    func determineIfCafeIsOpen() {
        // do this in PlacesFetcher
    }
    
    func sortCafesBasedOnDistanceFromUserLocation(array: [Cafe], userLocation: CLLocation) -> [Cafe] {
        let sortedArray = array.sorted { (first, second) -> Bool in
            guard let firstCoordinate = first.googlePlace?.coordinate else { return false }
            guard let secondCoordinate = second.googlePlace?.coordinate else { return true }
            let firstLocation = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
            let secondLocation = CLLocation(latitude: secondCoordinate.latitude, longitude: secondCoordinate.longitude)
            let firstDistance = firstLocation.distance(from: userLocation)
            let secondDistance = secondLocation.distance(from: userLocation)
            return firstDistance < secondDistance
        }
        return sortedArray
    }
    
    
    func segmentSetup() {
        segmentOutlet.selectedSegmentIndex = 0
        mapViewContainer.isHidden = false
        listViewContainer.isHidden = true
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        mapViewContainer.isHidden = true
        listViewContainer.isHidden = true
        if segmentOutlet.selectedSegmentIndex == 0 {
            mapViewContainer.isHidden = false
        } else {
            listViewContainer.isHidden = false
        }
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let queue = DispatchQueue(label: "segue Q")
        queue.async {
            while !self.fetchCompleted {
                //do nothing
            }
            DispatchQueue.main.async {
                if segue.identifier == Segues.toMapView {
                    let destinationVC = segue.destination as! MapViewController
                    let cafesToSend = self.cafes
                    destinationVC.locationService = self.locationService
                    print("🌞🌞🌞🌞🌞 Cafes To Send 🌞🌞🌞🌞🌞", cafesToSend )
                    destinationVC.mapCafes = cafesToSend
                    destinationVC.segueComplete = true
                    
                } else if segue.identifier == Segues.toListView {
                    let destinationVC = segue.destination as! ListViewController
                    let cafesToSend = self.cafes
                    print("🌒🌒🌒🌒🌒 Cafes To Send 🌒🌒🌒🌒🌒", cafesToSend )
                    
                    destinationVC.listCafes = cafesToSend
                    destinationVC.segueComplete = true
                    
                }
            }
        }
    }
    
} // END HOME


//extension HomeViewController: UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let query = self.homeSearchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty,
//              let resultVC = searchController.searchResultsController as? ResultsViewController else {
//            return
//        }
//
//        self.cafes(query:query) { result in
//            switch result {
//            case .success(let places):
//                print(places)
//
//                DispatchQueue.main.async {
//                    resultVC.update(with: places)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//
//} // End of Extension

//    func updateSearchResults(for searchController: UISearchController) {
//        guard let query = self.searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty,
//        let resultVC = searchController.searchResultsController as? ResultsViewController else {
//            return
//        }
//        
//        GooglePlacesManager.shared.findPlaces(query:query) { result in
//            switch result {
//            case .success(let places):
//                print(places)
//                
//                DispatchQueue.main.async {
//                    resultVC.update(with: places)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
