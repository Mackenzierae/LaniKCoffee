//
//  PlacesFetcher.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/12/23.
//

import Foundation
import GooglePlaces
import CoreLocation

class PlacesFetcher {
    static let shared = PlacesFetcher()

    
    func fetchPlace(placeId: String, completion: @escaping ( Result<GooglePlaceCafe?, PlaceError>) -> Void) {
        
        print("INSIDE PLACESFETCHER.FETCHPLACES. PlaceID:", placeId)
        
        let fields: GMSPlaceField = [.name, .formattedAddress, .website, .phoneNumber, .openingHours, .photos, .coordinate, .utcOffsetMinutes]
        
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: nil) { (place, error) in
            if let error = error {
                print("ERROR FETCHING FROM GMSPLACESCLIENT \(error.localizedDescription)")
                return completion(.failure(PlaceError.thrownError(error)))
            }
            
            guard let place = place else {
                return completion(.failure(PlaceError.placeError))
            }
            

//            let isOpenNow = place.isOpen()
//            let currentTime = Date()
//            let currentTimeInterval = currentTime.timeIntervalSince1970
//            let currentDateTime = Date(timeIntervalSince1970: currentTimeInterval)
//            let isOpenAtTime = place.isOpen(at: currentDateTime)
            
            
            // Extract the relevant data
           
            let name = place.name
            let address = place.formattedAddress
            let website = place.website?.absoluteString
            let phoneNumber = place.phoneNumber
            let openHoursWeekdayText: [String]?
            
            var isOpen = "IDKMAN"
            var openHoursObject = place.openingHours
            
          
//            var weekdays = openHoursObject?.value(forKey: "Weekdays")
        
            
            
            if ((place.openingHours?.weekdayText) != nil) {
                openHoursWeekdayText = place.openingHours?.weekdayText!
                print("🦋🦋🦋🦋🦋🦋We are going to run this isCafeOpen function🦋🦋🦋🦋🦋🦋🦋")
                isCafeOpen(timeRangeArr: openHoursWeekdayText!)
            } else {
                openHoursWeekdayText = nil
                print("💋💋💋💋 No weekday text!💋💋💋💋")
            }
            let openHoursPeriods = place.openingHours?.periods
            var image: UIImage?
            var geoCodedAddress: CLLocation?
            let coordinate = place.coordinate
            let latitude = place.coordinate.latitude
            let longitude = place.coordinate.longitude
            let businessStatus = place.businessStatus
        
            
            func isCafeOpen(timeRangeArr: [String]) {
               
                let date = Date()
                let calendar = Calendar.current
                let day = calendar.component(.weekday, from: date)
//                let hour = calendar.component(.hour, from: date)
//                let minute = calendar.component(.minute, from: date)
                let timeRanges = timeRangeArr // <--- update this line

                let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                let currentDay = daysOfWeek[day - 1]

                var currentDayTimeRange = ""

                for timeRange in timeRanges {
                    if timeRange.contains(currentDay) {
                        currentDayTimeRange = timeRange
                        print(currentDayTimeRange)
                        break
                    }
                }

                if currentDayTimeRange.contains("Closed") {
                    isOpen = "Closed Today"
                    print("🦁🦁🦁🦁closed today🦁🦁🦁🦁")
                } else {
                    isOpen = "\(currentDayTimeRange)"
//                    print("🐸🐸🐸🐸 time for heavy lifting 🐸🐸🐸🐸", currentDayTimeRange)
//                    let timeString = currentDayTimeRange.replacingOccurrences(of: "\(currentDay): ", with: "")
//                    print("🐸🐸🐸\(timeString)🦚🦚🦚🦚🦚")
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "h:mm a"
//

//                    let startTime = dateFormatter.date(from: String(timeString.prefix(7)))
//                    let endTime = dateFormatter.date(from: String(timeString.suffix(8)))
//
//
//                    let startTimeComponents = calendar.dateComponents([.hour, .minute], from: startTime!)
//                    let endTimeComponents = calendar.dateComponents([.hour, .minute], from: endTime!)
//
//                    let startTimeToday = calendar.date(bySettingHour: startTimeComponents.hour!, minute: startTimeComponents.minute!, second: 0, of: date)!
//                    let endTimeToday = calendar.date(bySettingHour: endTimeComponents.hour!, minute: endTimeComponents.minute!, second: 0, of: date)!
//
//                    if date.compare(startTimeToday) == .orderedDescending && date.compare(endTimeToday) == .orderedAscending {
//                        isOpen = "open1"
//                        print("🐣🐣🐣Current time is within the range.", startTimeComponents, endTimeComponents)
//                    } else if date.compare(startTimeToday) == .orderedAscending && date.compare(endTimeToday.addingTimeInterval(24*60*60)) == .orderedAscending {
//                        isOpen = "open2"
//                        print("🐣🐣🐣🐣🐣Current time is within the range.", startTimeComponents, endTimeComponents)
//                    } else {
//                        isOpen = "closed"
//                        print("🐣🐣🐣🐣🐣🐣🐣Current time is not within the range. \(startTime)🐣\(endTime).....")
//                    }

                }

            }


            let geoCoder = CLGeocoder()
            
            if (address != nil) {
                geoCoder.geocodeAddressString(address!) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let geoLocation = placemarks.first?.location
                    else {
                        // handle no location found
                        print("NO Location found 🐬🐬🐬🐬🐬🐬🐬🐬")
                        geoCodedAddress = nil
                        return photoSelection()
                    }
                    print("🌈🌈🌈🌈 GeoCodedAddress: 🌈🌈🌈🌈", geoLocation)
                    geoCodedAddress = geoLocation
                    photoSelection()
                }
            } else {
                photoSelection()
            }
            
            func photoSelection() {
                if let firstPhoto = place.photos?.first {
                    GMSPlacesClient.shared().loadPlacePhoto(firstPhoto, callback: { (photo, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return completion(.failure(PlaceError.imageError))
                        }
                        image = photo
                        returnCompletion()
                    })
                } else { // this is new:
                    image = UIImage(named: "defaultCafeImage")!
                    returnCompletion()
                }
            }
      
            func returnCompletion() {
                let fetchedPlace = GooglePlaceCafe(name: name, address: address, geoCodedAddress: geoCodedAddress, coordinate: coordinate, latitude: latitude, longitude: longitude, website: website, phoneNumber: phoneNumber, openHoursObject: openHoursObject, openHoursWeekdayText: openHoursWeekdayText, openHoursPeriods: openHoursPeriods, isOpen: isOpen, businessStatus: businessStatus, image: image)
                completion(.success(fetchedPlace))
            }
        }
    }
} // END Places Fetcher
