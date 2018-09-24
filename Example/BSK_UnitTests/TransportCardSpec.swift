//
//  TransportCardSpec.swift
//  BSK_Example
//
//  Created by m3g0byt3 on 20/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
// swiftlint:disable function_body_length implicitly_unwrapped_optional

import Foundation
import Quick
import Nimble
@testable import BSK

final class TransportCardSpec: QuickSpec {

    override func spec() {

        describe("TransportCard") {

            var transportCard: BSKTransportCard!

            afterEach {
                transportCard = nil
            }

            context("initialization") {

                var testCard: BSKTransportCard!
                var cardNumber: String!
                let nonNumericRegex = "[^0-9]+"

                afterEach {
                    testCard = nil
                    cardNumber = nil
                }

                it("from 11-digit number should return Sputnik transport card") {
                    cardNumber = [String](repeating: "1", count: 11).joined()
                    testCard = BSKTransportCard.sputnik(number: cardNumber)
                    transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard).to(equal(testCard))
                }

                it("from 19-digit number should return Podorozhnik Short transport card") {
                    cardNumber = [String](repeating: "1", count: 19).joined()
                    testCard = BSKTransportCard.podorozhnikShort(number: cardNumber)
                    transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard).to(equal(testCard))
                }

                it("from 26-digit number should return Podorozhnik Long transport card") {
                    cardNumber = [String](repeating: "1", count: 26).joined()
                    testCard = BSKTransportCard.podorozhnikLong(number: cardNumber)
                    transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard).to(equal(testCard))
                }

                it("should remove non-numeric characters symbols from card number") {
                    cardNumber = [String](repeating: "1-", count: 11).joined()
                    transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard.cardNumber).toNot(match(nonNumericRegex))
                }
            }

            context("cardType value") {

                it("must be equal 1 for Podorozhnik Short transport card") {
                    transportCard = BSKTransportCard.podorozhnikShort(number: "1")

                    expect(transportCard.cardType).to(equal(1))
                }

                it("must be equal 1 for Podorozhnik Long transport card") {
                    transportCard = BSKTransportCard.podorozhnikLong(number: "1")

                    expect(transportCard.cardType).to(equal(1))
                }

                it("must be equal 2 for Sputnik transport card") {
                    transportCard = BSKTransportCard.sputnik(number: "1")

                    expect(transportCard.cardType).to(equal(2))
                }
            }
        }
    }
}
