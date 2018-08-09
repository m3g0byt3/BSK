//
//  BSKTransportCard.swift
//  BSK
//
//  Created by m3g0byt3 on 29/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

/// Transport card model
public enum BSKTransportCard {

    case podorozhnikShort(number: String)
    case podorozhnikLong(number: String)
    case sputnik(number: String)

    // MARK: - Constants

    /// Regex string used to remove non-numeric characters from raw card number
    private static let regexString = "([^0-9]+)"
    /// Replacement string for non-numeric characters from raw card number
    private static let nonNumericReplacement = ""

    private enum NumberLength {
        static let sputnik = 11
        static let podorozhnikShort = 19
        static let podorozhnikLong = 26
    }

    // MARK: - Public properties

    /// Transport card number
    public var cardNumber: String {
        switch self {
        case .podorozhnikLong(let number), .podorozhnikShort(let number), .sputnik(let number):
            return number
        }
    }

    /// Transport card type
    public var cardType: Int {
        switch self {
        case .podorozhnikLong, .podorozhnikShort: return 1
        case .sputnik: return 2
        }
    }

    // MARK: - Initialization

    /// Convenience init with given transport card number.
    /// - parameter number: Transport card number.
    public init?(cardNumber number: String) {
        let normalizedNumber = number.replacingOccurrences(of: BSKTransportCard.regexString,
                                                           with: BSKTransportCard.nonNumericReplacement,
                                                           options: .regularExpression)
        switch normalizedNumber.count {
        case NumberLength.sputnik: self = .sputnik(number: normalizedNumber)
        case NumberLength.podorozhnikShort: self = .podorozhnikShort(number: normalizedNumber)
        case NumberLength.podorozhnikLong: self = .podorozhnikLong(number: normalizedNumber)
        default: return nil
        }
    }
}

// MARK: - CustomStringConvertible protocol conformance

extension BSKTransportCard: CustomStringConvertible {

    public var description: String {
        let cardType: String
        let maskedNumber = cardNumber
            .dropLast(6)
            .map { _ in "●" }
            .joined()
            .appending(cardNumber.suffix(6))

        switch self {
        case .sputnik: cardType = "Sputnik"
        case .podorozhnikShort: cardType = "Podorozhnik (Short number format)"
        case .podorozhnikLong: cardType = "Podorozhnik (Long number format)"
        }

        return "Transport card \(cardType): \(maskedNumber)"
    }
}

// MARK: - CustomReflectable protocol conformance

extension BSKTransportCard: CustomReflectable {

    public var customMirror: Mirror {
        return Mirror(reflecting: type(of: self))
    }
}

// MARK: - Equatable protocol conformance

extension BSKTransportCard: Equatable {
    // swiftlint:disable:next operator_whitespace
    public static func ==(lhs: BSKTransportCard, rhs: BSKTransportCard) -> Bool {

        switch (lhs, rhs) {
        case let (.sputnik(lNumber), .sputnik(rNumber)):
            return lNumber == rNumber
        case let (.podorozhnikShort(lNumber), .podorozhnikShort(rNumber)):
            return lNumber == rNumber
        case let (.podorozhnikLong(lNumber), .podorozhnikLong(rNumber)):
            return lNumber == rNumber
        default:
            return false
        }
    }
}
