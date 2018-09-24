//
//  PaymentMethodSpec.swift
//  BSK_Tests
//
//  Created by m3g0byt3 on 31/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import BSK

final class PaymentMethodSpec: QuickSpec {

    override func spec() {

        describe("PaymentMethod") {

            context("CreditCard") {

                // MARK: - Properties

                var creditCardPaymentMethod: BSKPaymentMethod.CreditCard!
                let cardNumberString = "1234123412341234"
                let cardDefaultCVV = "000"
                let cardNonDefaultCVV = "999"
                let cardExpiryMonthTwoDigit: UInt = 01
                let cardExpiryYearTwoDigit: UInt = 99
                let cardExpiryYearFourDigit: UInt = 2099

                // MARK: - Helpers

                func randomNumberStringWithLength(from lower: Int, to upper: Int) -> String {
                    return (UInt32(lower)...(arc4random_uniform(UInt32(upper)) + UInt32(lower)))
                        .map { _ in "\(arc4random_uniform(10))" }
                        .joined()
                }

                // MARK: - Setup/teardown

                beforeEach {
                    creditCardPaymentMethod = nil
                }

                // MARK: - Tests

                it("should fail initialization when card number is too short") {
                    let number = randomNumberStringWithLength(from: 0, to: cardNumberString.count - 1)
                    creditCardPaymentMethod = BSKPaymentMethod.CreditCard(cardNumber: number,
                                                                          expiryMonth: cardExpiryMonthTwoDigit,
                                                                          expiryYear: cardExpiryYearTwoDigit)

                    expect(creditCardPaymentMethod).to(beNil())
                }

                it("should fail initialization when card number is too long") {
                    let number = randomNumberStringWithLength(from: cardNumberString.count + 1, to: cardNumberString.count * 2)
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
