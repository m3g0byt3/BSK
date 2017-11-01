//
//  BSKTransactionDelegate.swift
//  BSK
//
//  Created by m3g0byt3 on 31/10/2017.
//

import Foundation

public protocol BSKTransactionDelegate: class {
    
    func didReceiveConfirmationRequest(_ request: URLRequest)
    
    func transactionDidFailWithError(_ error: BSKError)
    
    func transactionDidComplete()
}
