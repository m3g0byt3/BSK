//
//  MockDelegate.swift
//  BSK_Example
//
//  Created by m3g0byt3 on 13/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import BSK

internal class MockDelegate: BSKTransactionDelegate {
    
    func transactionDidComplete() {
        fatalError("\(#function) not implemented yet")
    }
    
    func transactionDidFailWithError(_ error: BSKError) {
        fatalError("\(#function) not implemented yet")
    }
    
    func didReceiveConfirmationRequest(_ request: URLRequest) {
        fatalError("\(#function) not implemented yet")
    }
}
