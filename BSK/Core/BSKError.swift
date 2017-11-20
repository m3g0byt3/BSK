//
//  BSKError.swift
//  BSK
//
//  Created by m3g0byt3 on 28/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

public enum BSKError: Error {
    
    case maintenanceMode, wrongCardNumber, wrongSum, topUpError, parseError, networkError(String), busy, genericError
    
    /// Localized description of an error
    public var localizedDescription: String {
        switch self {
        case .maintenanceMode:
            return "Maintenance mode on back-end, try again later"
        case .wrongCardNumber:
            return "Wrong transport card number"
        case .wrongSum:
            return "Incorrect top up amount.\r\n Minimum top up amount 1 RUB, maximum top up amount 15000 RUB"
        case .topUpError:
            return "Unable to top-up transport card"
        case .parseError:
            return "Unable to parse response from back-end"
        case .networkError(let description):
            return description
        case .busy:
            return "Another request in progress"
        case .genericError:
            return "Unknown error"
        }
    }
}

public extension BSKError {
    /**
     * Convenience init from `Error` type
     * - parameter error: Type conforming to `Error` protocol
     */
    public init(_ error: Error) {
        self = .networkError(error.localizedDescription)
    }
}
