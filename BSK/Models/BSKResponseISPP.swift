//
//  BSKResponseISPP.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//

import Foundation

struct BSKResponseISPP: BSKMappable {

    // MARK: - Constants

    private static let separator: Character = "\""

    // MARK: - Public properties

    let sessionID: String
    let transactionID: String

    // MARK: - Initialization

    init(_ data: Data) throws {
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw BSKError.unableToMapResponse
        }

        if responseString.contains(Constants.BackendError.maintenanceMode) {
            throw BSKError.maintenanceMode
        }

        if responseString.contains(Constants.BackendError.wrongSum) {
            throw BSKError.wrongSum
        }

        if responseString.contains(Constants.BackendError.wrongCardNumber) {
            throw BSKError.wrongCardNumber
        }

        let paymentURLString = responseString
            .split(separator: BSKResponseISPP.separator)
            .first { $0.contains(Constants.mbmBaseURL) }
            .map(String.init)

        guard let paymentURL = paymentURLString.flatMap(URL.init) else {
            throw BSKError.unableToMapResponse
        }

        self.sessionID = paymentURL.deletingLastPathComponent().lastPathComponent
        self.transactionID = paymentURL.lastPathComponent
    }
}
