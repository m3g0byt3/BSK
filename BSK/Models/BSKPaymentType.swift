//
//  BSKPaymentType.swift
//  BSK
//
//  Created by m3g0byt3 on 30/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

/// Represents types of payment, raw values equals API `paytype` parameter.
public enum BSKPaymentType {

    private enum RawValues {
        static let yandex = 3
        static let phone = 4
        static let card = 6
        static let qiwi = 7
    }

    case creditCard(BSKPaymentMethod.CreditCard?)

    @available(*, unavailable, message: "Not supported yet")
    case yandexMoney

    @available(*, unavailable, message: "Not supported yet")
    case phoneBalance

    @available(*, unavailable, message: "Not supported yet")
    case qiwiWallet
}

// MARK: - RawRepresentable protocol conformance

extension BSKPaymentType: RawRepresentable {

    public init?(rawValue: Int) {
        switch rawValue {
        case RawValues.card: self = .creditCard(nil)
        default: return nil
        }
    }

    public var rawValue: Int {
        switch self {
        case .yandexMoney: return RawValues.yandex
        case .phoneBalance: return RawValues.phone
        case .creditCard: return RawValues.card
        case .qiwiWallet: return RawValues.qiwi
        }
    }
}

// MARK: - CustomStringConvertible protocol conformance

extension BSKPaymentType: CustomStringConvertible {

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
