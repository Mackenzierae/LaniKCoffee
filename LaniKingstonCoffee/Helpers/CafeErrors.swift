//
//  CafeErrors.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/9/23.
//

import Foundation

enum CafeError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
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
        }
    }
}
