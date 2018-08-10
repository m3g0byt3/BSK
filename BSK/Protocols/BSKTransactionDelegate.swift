//
//  BSKTransactionDelegate.swift
//  BSK
//
//  Created by m3g0byt3 on 31/10/2017.
//

import Foundation

/// Allow the delegate load 3DS confirmation requests and handle errors during payment processing.
public protocol BSKTransactionDelegate: class {

    /// 3DS confirmation request received.
    /// - parameter request: 3DS confirmation request.
    func didReceiveConfirmationRequest(_ request: URLRequest)

    /// An error occurred during payment.
    /// - parameter error: Unrecoverable error.
    func transactionDidFailWithError(_ error: BSKError)

    /// Payment completed successfully.
    func transactionDidComplete()
}
