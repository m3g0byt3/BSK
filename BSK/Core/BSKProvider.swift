//
//  BSKProvider.swift
//  BSK
//
//  Created by m3g0byt3 on 28/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation
import Moya

enum BSKProvider {
    
    case initiatePayment(transportCard: TransportCard, amount: Decimal)
    case processPayment(sessionID: String, transactionID: String)
}

extension BSKProvider: TargetType {
    
    /// The target's base `URL`.
    var baseURL: URL {
        switch self {
        case .initiatePayment:
            return URL(string: Constants.isppBaseURL)!
        case .processPayment:
            return URL(string: Constants.mbmBaseURL)!
        }
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .initiatePayment:
            return Constants.isppPath
        case .processPayment(let sessionID, let transactionID):
            return Constants.mbmProcessingPath + "\(sessionID)/\(transactionID)/"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .initiatePayment:
            return .post
        case .processPayment:
            return .get
        }
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        //TODO: add actual stub data for use in testing.
        return "".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case .initiatePayment(let transportCard, let amount):
            
            let parameters = [Constants.RequestParameters.numberParameterName: transportCard.cardNumber,
                              Constants.RequestParameters.cardTypeParameterName: String(transportCard.cardType),
                              Constants.RequestParameters.sumParameterName: amount.description,
                              Constants.RequestParameters.paymentTypeParameterName: String(PaymentType.creditCard.rawValue)]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .processPayment:
            return .requestPlain
        }
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return true
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        return Constants.headers
    }
}
