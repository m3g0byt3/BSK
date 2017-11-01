//
//  PaymentType.swift
//  BSK
//
//  Created by m3g0byt3 on 30/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

public enum PaymentType: Int {
    
    case yandexMoney = 3
    case phoneBalance = 4
    case creditCard = 6
    case qiwiWallet = 7
}

//MARK: - CustomStringConvertible protocol conformance
extension PaymentType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .yandexMoney:
            return "Payment type: Yandex Money payment system"
        case .phoneBalance:
            return "Payment type: Cell phone balance"
        case .creditCard:
            return "Payment type: Credit or debit card"
        case .qiwiWallet:
            return "Payment type: Qiwi Wallet payment system"
        }
    }
}
