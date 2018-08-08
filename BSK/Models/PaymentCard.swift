//
//  PaymentCard.swift
//  BSK
//
//  Created by m3g0byt3 on 29/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

/// Payment card model
public struct PaymentCard {
    // TODO: At least `cardNumber` must be not optional
    /// Payment card number
    public var cardNumber: String?
    /// Payment card CVV code
    public var cvv: String?
    /// Payment card expiration month
    public var expiryMonth: UInt?
    /// Payment card expiration year
    public var expiryYear: UInt?

    /// Payment card is ready to use (has all required data - number, CVV code and expiration date)
    public var isReady: Bool {
        guard let number = cardNumber, let code = cvv, expiryMonth != nil, expiryYear != nil else { return false }

        return code.count == 3 && number.count == 16
    }

    /// Public memberwise initializer
    public init(cardNumber: String?, cvv: String?, expiryMonth: UInt?, expiryYear: UInt?) {
        self.cardNumber = cardNumber
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
    }
}

// MARK: - Custom init

/// Provides convenience init with given credit card number
public extension PaymentCard {

    /// Convenience init with given credit card number
    /// - parameter cardNumber: credit card number
    public init?(_ cardNumber: String) {
        guard cardNumber.count == 16 else { return nil }

        self.init(cardNumber: cardNumber, cvv: nil, expiryMonth: nil, expiryYear: nil)
    }
}

// MARK: - CustomStringConvertible protocol conformance

extension PaymentCard: CustomStringConvertible {

    public var description: String {
        guard let number = cardNumber else { return "No payment card number provided" }

        let expiryString: String

        if let month = expiryMonth, let year = expiryYear {
            expiryString = "\(month)/\(year)"
        } else {
            expiryString = ""
        }

        return "Payment card ●●●● ●●●● ●●●● \(number.suffix(4)) \(expiryString) \(cvv ?? "")"
    }
}
