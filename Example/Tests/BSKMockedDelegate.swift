//
//  BSKMockedDelegate.swift
//  BSK_Example
//
//  Created by m3g0byt3 on 13/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import BSK

internal class BSKMockedDelegate: BSKTransactionDelegate {
    
    // Properties used in async delegate testing
    var transactionCompleted = false
    var transactionRequest: URLRequest?
    var transactionError: BSKError?

    func transactionDidComplete() {
        transactionCompleted = true
    }
    
    func transactionDidFailWithError(_ error: BSKError) {
        transactionError = error
    }
    
    func didReceiveConfirmationRequest(_ request: URLRequest) {
        transactionRequest = request
    }
}
