//
//  BSKPaymentMethodSpec.swift
//  BSK_Tests
//
//  Created by m3g0byt3 on 31/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import BSK

final class BSKPaymentMethodSpec: QuickSpec {

    override func spec() {

        describe("PaymentMethod") {

            context("CreditCard") {

                // MARK: - Properties

                var creditCardPaymentMethod: BSKPaymentMethod.CreditCard!
                let cardNumberString = String.randomNumberStringWithLength(within: 16..<17)
                let cardNonDefaultCVV = String.randomNumberStringWithLength(within: 3..<4)
                let cardDefaultCVV = "000"
                let cardExpiryMonthTwoDigit: UInt = 01
                let cardExpiryYearTwoDigit: UInt = 99
                let cardExpiryYearFourDigit: UInt = 2099

                // MARK: - Setup/teardown

                beforeEach {
                    creditCardPaymentMethod = nil
                }

                // MARK: - Tests

                it("should fail initialization when card number is too short") {
                    let number = String.randomNumberStringWithLength(within: 0..<cardNumberString.count)
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: number,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit)

                    expect(creditCardPaymentMethod).to(beNil())
                }

                it("should fail initialization when card number is too long") {
                    let number = String.randomNumberStringWithLength(within: cardNumberString.count + 1..<cardNumberString.count * 2)
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: number,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit)

                    expect(creditCardPaymentMethod).to(beNil())
                }

                it("should initialize with 16-digit card number, 2-digit expiry month, 2-digit expiry year and default CVV") {
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: cardNumberString,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit)

                    expect(creditCardPaymentMethod.cardNumber) == cardNumberString
                    expect(creditCardPaymentMethod.expiryMonth) == cardExpiryMonthTwoDigit
                    expect(creditCardPaymentMethod.expiryYear) == cardExpiryYearFourDigit
                    expect(creditCardPaymentMethod.cvv) == cardDefaultCVV
                }

                it("should initialize with 16-digit card number, 2-digit expiry month, 4-digit expiry year and default CVV") {
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: cardNumberString,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit)

                    expect(creditCardPaymentMethod.cardNumber) == cardNumberString
                    expect(creditCardPaymentMethod.expiryMonth) == cardExpiryMonthTwoDigit
                    expect(creditCardPaymentMethod.expiryYear) == cardExpiryYearFourDigit
                    expect(creditCardPaymentMethod.cvv) == cardDefaultCVV
                }

                it("should initialize with 16-digit card number, 2-digit expiry month, 2-digit expiry year and given CVV") {
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: cardNumberString,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit,
                                                                          cvv: cardNonDefaultCVV)

                    expect(creditCardPaymentMethod.cardNumber) == cardNumberString
                    expect(creditCardPaymentMethod.expiryMonth) == cardExpiryMonthTwoDigit
                    expect(creditCardPaymentMethod.expiryYear) == cardExpiryYearFourDigit
                    expect(creditCardPaymentMethod.cvv) == cardNonDefaultCVV
                }

                it("should initialize with 16-digit card number, 2-digit expiry month, 4-digit expiry year and given CVV") {
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: cardNumberString,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit,
                                                                          cvv: cardNonDefaultCVV)

                    expect(creditCardPaymentMethod.cardNumber) == cardNumberString
                    expect(creditCardPaymentMethod.expiryMonth) == cardExpiryMonthTwoDigit
                    expect(creditCardPaymentMethod.expiryYear) == cardExpiryYearFourDigit
                    expect(creditCardPaymentMethod.cvv) == cardNonDefaultCVV
                }
            }
        }
    }
}
