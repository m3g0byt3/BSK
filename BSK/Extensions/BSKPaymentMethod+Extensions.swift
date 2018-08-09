//
//  PaymentCard+Extensions.swift
//  Alamofire
//
//  Created by m3g0byt3 on 09/08/2018.
//

import Foundation

extension BSKPaymentMethod.CreditCard {

    /// HTTP body based on provided payment card information
    var httpBody: Data? {
        return ["CardDataInputForm%5Bpan%5D=\(cardNumber)",
            "CardDataInputForm%5Bcvv2%5D=\(cvv)",
            "CardDataInputForm%5Bmonth%5D=\(expiryMonth)",
            "CardDataInputForm%5Byear%5D=\(expiryYear)",
            "CardDataInputForm%5Bholder%5D=Card Holder",
            "CardDataInputForm%5Bphone%5D=79990000000"]
            .joined(separator: "&")
            .data(using: .utf8)
    }
}

// MARK: - CustomStringConvertible protocol conformance

extension BSKPaymentMethod.CreditCard: CustomStringConvertible {

    public var description: String {
        let expiryString = "\(expiryMonth)/\(expiryYear)"

        return "Payment card: ●●●● ●●●● ●●●● \(cardNumber.suffix(4)) \(expiryString)"
    }
}

// MARK: - CustomReflectable protocol conformance

extension BSKPaymentMethod.CreditCard: CustomReflectable {

    public var customMirror: Mirror {
        return Mirror(reflecting: type(of: self))
    }
}
