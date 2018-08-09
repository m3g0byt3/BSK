//
//  BSKError.swift
//  BSK
//
//  Created by m3g0byt3 on 28/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

/// Errors that may be trown by `BSKAdapter`.
public enum BSKError: Error {

    case maintenanceMode
    case wrongCardNumber
    case wrongSum
    case paymentMethodNotSupported
    case unableToMapResponse
    case unableToTopUp
    case underlying(Error)
    case busy

    /// Localized description of an error
    public var localizedDescription: String {
        switch self {
        case .maintenanceMode:
            return "Maintenance mode on back-end, try again later"
        case .wrongCardNumber:
            return "Wrong transport card number"
        case .wrongSum:
            return "Incorrect top-up amount.\r\n Minimum top-up amount 1 RUB, maximum top-up amount 14500 RUB"
        case .unableToTopUp:
            return "Unable to top-up transport card"
        case .underlying(let error):
            return error.localizedDescription
        case .busy:
            return "Another request in progress"
        case .paymentMethodNotSupported:
            return "Currently supported payments methods: `Credit card`"
        case .unableToMapResponse:
            return "Unable to map response to object"
        }
    }
}
