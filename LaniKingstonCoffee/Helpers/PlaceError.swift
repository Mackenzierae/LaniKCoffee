//
//  PlaceError.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/12/23.
//

import Foundation

enum PlaceError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case placeError
    case imageError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach to FireStore"
        case .thrownError(let error):
            return error.localizedDescription
        case .noData:
            return "the server responded with no data"
        case .unableToDecode:
            return "the server responded with bad data"
        case .placeError:
            return "There was ann error with guard let place = place"
        case .imageError:
            return "There is something wrong with the image"
        }
    }
}
