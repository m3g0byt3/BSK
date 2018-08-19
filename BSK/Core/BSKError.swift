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
    case unableToTopUp
    case unableToMapResponse
    case busy
    case underlying(Error)
}

extension BSKError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .maintenanceMode: return "Maintenance mode on back-end, please try again later."
        case .wrongCardNumber: return "Incorrect transport card number."
        case .wrongSum: return "Incorrect top-up amount. Allowed top-up amount: from 1₽ to 14500₽."
        case .paymentMethodNotSupported: return "Currently supported payments methods: \"Credit card\"."
        case .unableToTopUp: return "Unable to top-up transport card."
        case .unableToMapResponse: return "Unable to receive server's response."
        case .busy: return "Another payment request in progress."
        case .underlying(let error as LocalizedError): return error.errorDescription ?? "Unknown underlying errror."
        case .underlying: return "Unknown underlying error."
        }
    }
}

extension BSKError: CustomNSError {

    public var errorCode: Int {
        switch self {
        case .maintenanceMode: return 1
        case .wrongCardNumber: return 2
        case .wrongSum: return 3
        case .paymentMethodNotSupported: return 4
        case .unableToTopUp: return 5
        case .unableToMapResponse: return 6
        case .busy: return 7
        case .underlying(let error as CustomNSError): return error.errorCode
        case .underlying: return 99
        }
    }
}
