//
//  TransportCard.swift
//  BSK
//
//  Created by m3g0byt3 on 29/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

public enum TransportCard {
    
    case podorozhnikShort(number: String), podorozhnikLong(number: String), sputnik(number: String)
    
    /// regex string used to remove non-numeric characters from raw card number
    fileprivate static let regexString = "([^0-9]+)"
    
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
}

//MARK: - Custom init
public extension TransportCard {
    
    /// Convenience init with given transport card number
    public init?(cardNumber number: String) {
        
        let normalizedNumber = number.replacingOccurrences(of: TransportCard.regexString, with: "", options: .regularExpression)
        
        switch normalizedNumber.count {
        case 11:
            self = .sputnik(number: normalizedNumber)
        case 19:
            self = .podorozhnikShort(number: normalizedNumber)
        case 26:
            self = .podorozhnikLong(number: normalizedNumber)
        default:
            return nil
        }
    }
}

//MARK: - CustomStringConvertible protocol conformance
extension TransportCard: CustomStringConvertible {
    
    public var description: String {
        let cardType: String
        
        switch self {
        case .sputnik: cardType = "Sputnik"
        case .podorozhnikShort: cardType = "Podorozhnik (Short number format)"
        case .podorozhnikLong: cardType = "Podorozhnik (Long number format)"
        }
        
        return "Transport card \(cardType): \(cardNumber)"
    }
}

//MARK: - Equatable protocol conformance
extension TransportCard: Equatable {
    
    public static func ==(lhs: TransportCard, rhs: TransportCard) -> Bool {
        
        switch (lhs, rhs) {
        case (.sputnik(let lNumber), .sputnik(let rNumber)):
            return lNumber == rNumber
        case (.podorozhnikShort(let lNumber), .podorozhnikShort(let rNumber)):
            return lNumber == rNumber
        case (.podorozhnikLong(let lNumber), .podorozhnikLong(let rNumber)):
            return lNumber == rNumber
        default:
            return false
        }
    }
}
