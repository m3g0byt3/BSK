//
//  BSKResponseMBM.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//

import Foundation

struct BSKResponseMBM {

    // MARK: - Public properties

    let request: URLRequest

    // MARK: - Initialization

    init(transactionID: String, paymentCard: BSKPaymentMethod.CreditCard) throws {
        guard let url = URL(string: Constants.mbmBaseURL)?
            .appendingPathComponent(Constants.mbmConfirmationPath)
            .appendingPathComponent(transactionID)
        else { throw BSKError.unableToMapResponse }

        var request = try URLRequest(url: url, method: .post, headers: Constants.headers)

        request.httpBody = paymentCard.httpBody
        request.timeoutInterval = 15
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        self.request = request
    }
}
