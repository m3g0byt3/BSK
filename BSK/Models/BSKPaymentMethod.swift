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

        private static let defaultCVV = "00"
        private static let cardNumberLength = 16
        private static let formatter: DateFormatter = { this in
            this.dateFormat = "YYYY"
            return this
        }(DateFormatter())

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
                let normalizedExpiryYear = CreditCard.normalize(expiryYear)
            else { return nil }

            self.cardNumber = cardNumber
            self.expiryMonth = expiryMonth
            self.expiryYear = normalizedExpiryYear
            self.cvv = cvv ?? CreditCard.defaultCVV
        }

        // MARK: - Private API

        private static func normalize(_ rawYearNumber: UInt) -> UInt? {
            let currentDate = Date()
            let currentYearString = CreditCard.formatter.string(from: currentDate)
            let currentYearLength = currentYearString.count
            let rawYearString = String(rawYearNumber)
            let rawYearLength = rawYearString.count
            let offset = currentYearLength - rawYearLength
            let startIndex = currentYearString.startIndex
            let endIndex = currentYearString.index(startIndex, offsetBy: offset)
            let normalizedYearString = currentYearString[..<endIndex] + rawYearString

            return UInt(normalizedYearString)
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
