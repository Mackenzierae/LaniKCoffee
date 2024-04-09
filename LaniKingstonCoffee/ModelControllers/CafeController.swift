//
//  CafeController.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/4/23.
//

import FirebaseFirestore
import Foundation

class CafeController {
    
    var counter = 0
    var fetchFinish = false
    static let shared = CafeController()
    let db = Firestore.firestore()
    var cafes : [Cafe] = []
    
    func fetchCafes(completion: @escaping ( Result<[Cafe], CafeError>) -> Void) {
        var cafePlaceID = ""
        var fetchedGooglePlace: GooglePlaceCafe?
        var arrayOfCafes : [Cafe] = []
        db.collection("cafes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return completion(.failure(CafeError.thrownError(err)))
            } else {
                print("Inside Fetch ELSE (no error)")
                let group = DispatchGroup()
                
                for document in querySnapshot!.documents {
                    group.enter()
                    cafePlaceID = document.data()["location"] as? String ?? ""
                    
                    grabPlaceIdData(placeId: cafePlaceID, document: document) { result in
                        switch result {
                        case .success(let cafe):
                            print("🐡 Cafe Appended to arrayOFCafes❄️❄️❄️❄️", cafe)
                            arrayOfCafes.append(cafe)
                        case .failure(let error):
                            print(error.localizedDescription)
                            
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(arrayOfCafes))
                }
            }
        }
        
        // helper methods
        func grabPlaceIdData(placeId: String, document: QueryDocumentSnapshot, completion: @escaping (Result<Cafe, CafeError>) -> Void) {
            counter += 1
            PlacesFetcher.shared.fetchPlace(placeId: placeId) { result in
                switch result {
                case .success(let res):
                    fetchedGooglePlace = res
                    print("❄️❄️❄️❄️❄️❄️❄️ Inside PlacesFetcher.shared.fetchPlace success ❄️❄️❄️❄️❄️❄️❄️")
                    let cafe = Cafe(
                        googlePlace: fetchedGooglePlace,
                                  name: document.data()["name"] as? String ?? "nil name",
                                  placeId: document.data()["location"] as? String ?? "",
                                  wifi: document.data()["wifi"] as? Bool ?? false,
                                  wheelchair_accessible: document.data()["wheelchair_accessible"] as? Bool ?? false,
                                  indoor_seating: document.data()["indoor_seating"] as? Bool ?? false,
                                  outdoor_seating: document.data()["outdoor_seating"] as? Bool ?? false,
                                  dog_friendly: document.data()["dog_friendly"] as? Bool ?? false)
                    completion(.success(cafe))
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
}



//    let One = Cafe(id: 1, name: "Fourtillfour Cafe", placeId: "ChIJaRaK3r8LK4cRMS2pbjGFGM4", wifi: true, wheelchair_accessible: true, indoor_seating: false, outdoor_seating: true, dog_friendly: true)
//    let Two = Cafe(id: 2, name: "Dark Hall Coffee", placeId: "ChIJndzGmvcSK4cRPWLHMOJ7i60", wifi: true, wheelchair_accessible: true, indoor_seating: false, outdoor_seating: true, dog_friendly: false)
//    let Three = Cafe(id: 3, name: "Café-Flor", placeId: "ChIJ_abIqHtZwokRLWbw0G-lzu8", wifi: true, wheelchair_accessible: false, indoor_seating: true, outdoor_seating: true, dog_friendly: false)
//    let Four = Cafe(id: 4, name: "THE ELK on Mott", placeId: "ChIJD0qS2pJZwokR8xZL5jKXr_A", wifi: false, wheelchair_accessible: true, indoor_seating: true, outdoor_seating: true, dog_friendly: true)
//    let Five = Cafe(id: 5, name: "Waveon Coffee", placeId: "ChIJ-Q0IE9KGaDUR-hnQ05hxW4g", wifi: true, wheelchair_accessible: true, indoor_seating: true, outdoor_seating: true, dog_friendly: true)
//    let Six = Cafe(id: 6, name: "Electrica Coffee", placeId: "ChIJA1ld3soJlVQRP3oph9LrJF4", wifi: false, wheelchair_accessible: false, indoor_seating: true, outdoor_seating: false, dog_friendly: false)
//    let Seven = Cafe(id: 7, name: "Wild Rose Coffee", placeId: "ChIJ_ZcaBhcJlVQRgVRXLLcDBmk", wifi: true, wheelchair_accessible: true, indoor_seating: true, outdoor_seating: false, dog_friendly: false)
//    let Eight = Cafe(id: 8, name: "Prince Coffee", placeId: "ChIJt83ZHtOmlVQRc7Xyr2Fydc4", wifi: true, wheelchair_accessible: true, indoor_seating: true, outdoor_seating: true, dog_friendly: false)
//    let Nine = Cafe(id: 9, name: "Keeper Coffee Co", placeId: "ChIJwVBb6R0LlVQR52pe_0J9y4E", wifi: false, wheelchair_accessible: true, indoor_seating: true, outdoor_seating: true, dog_friendly: false)
//    let Ten = Cafe(id: 10, name: "40 LBS Coffee Bar", placeId: "ChIJU4tRdw8KlVQRmKqZNp2bgpg", wifi: true, wheelchair_accessible: true, indoor_seating: true, outdoor_seating: false, dog_friendly: false)
 
//    var testCafes: [Cafe] = []
//    init() {
//            self.testCafes = [One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten]
//        }


