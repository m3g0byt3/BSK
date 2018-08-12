//
//  BSKPaymentMethod.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//

import Foundation

/// Payment method models
public enum BSKPaymentMethod {

    /// Credit/debit card payment method
    public struct CreditCard {

        // MARK: - Constants

        // swiftlint:disable:next number_separator
        private static let yearBoundary = (min: 1000, max: 9999)
        private static let defaultCVV = "000"
        private static let cardNumberLength = 16

        // MARK: - Public properties

        /// Payment card number
        public var cardNumber: String
        /// Payment card CVV code
        public var cvv: String
        /// Payment card expiration month
        public var expiryMonth: UInt
        /// Payment card expiration year
        public var expiryYear: UInt

        // MARK: - Initialization

        /// Public failable initializer.
        /// parameters:
        ///     - cardNumber: Credit/debit card number string
        ///     - expiryMonth: expiration month
        ///     - expiryYear: expiration year
        ///     - cvv: CVV/CVC number string, default value "000"
        public init?(cardNumber: String, expiryMonth: UInt, expiryYear: UInt, cvv: String? = nil) {
            let validationComponents = DateComponents(calendar: Calendar.current,
                                                      year: Int(expiryYear),
                                                      month: Int(expiryMonth))
            guard
                cardNumber.count == CreditCard.cardNumberLength,
                validationComponents.isValidDate,
                expiryYear >= CreditCard.yearBoundary.min,
                expiryYear <= CreditCard.yearBoundary.max
            else { return nil }

            self.cardNumber = cardNumber
            self.expiryMonth = expiryMonth
            self.expiryYear = expiryYear
            self.cvv = cvv ?? CreditCard.defaultCVV
        }
    }

    /// YandexMoney payment method
    @available(*, unavailable, message: "Not supported yet")
    public struct YandexMoney {}

    /// QiwiWallet payment method
    @available(*, unavailable, message: "Not supported yet")
    public struct QiwiWallet {}

    /// CellPhone balance payment method
    @available(*, unavailable, message: "Not supported yet")
    public struct CellPhone {}
}
