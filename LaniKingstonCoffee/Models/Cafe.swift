//
//  Cafe.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/3/23.
//
import GoogleMaps
import GooglePlaces
import Foundation

struct Cafe : Equatable {
    
    var googlePlace: GooglePlaceCafe?
    var name: String
    var placeId: String
    var wifi: Bool
    var wheelchair_accessible: Bool
    var indoor_seating: Bool
    var outdoor_seating: Bool
    var dog_friendly: Bool
    
    
    // Equatable Conformance
    static func == (lhs: Cafe, rhs: Cafe) -> Bool {
        return lhs.placeId == rhs.placeId
    }
}


struct GooglePlaceCafe {
    var name: String?
    var address: String?
    var geoCodedAddress: CLLocation?
    var coordinate: CLLocationCoordinate2D?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var website: String?
    var phoneNumber: String?
    var openHoursObject: GMSOpeningHours?
    var openHoursWeekdayText: [String]?
    var openHoursPeriods: [GMSPeriod]?
    var isOpen: String
    var businessStatus: GMSPlacesBusinessStatus?
    var image: UIImage?
//    var weekdays: Any?
}
