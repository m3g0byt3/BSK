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

class TransportCardSpec: QuickSpec {

    override func spec() {

        describe("TransportCard") {

            var transportCard: TransportCard!
            var cardNumber: String!

            afterEach {
                transportCard = nil
                cardNumber = nil
            }

            context("initialization") {

                it("from 11-digit number should return Sputnik transport card") {
                    cardNumber = [String](repeating: "1", count: 11).joined()
                    transportCard = TransportCard(cardNumber: cardNumber)

                    let testCard = TransportCard.sputnik(number: cardNumber)

                    expect(transportCard).toNot(beNil())
                    expect(transportCard) == testCard
                }

                it("from 19-digit number should return Podorozhnik Short transport card") {
                    cardNumber = [String](repeating: "1", count: 19).joined()
                    transportCard = TransportCard(cardNumber: cardNumber)

                    let testCard = TransportCard.podorozhnikShort(number: cardNumber)

                    expect(transportCard).toNot(beNil())
                    expect(transportCard) == testCard
                }

                it("from 26-digit number should return Podorozhnik Long transport card") {
                    cardNumber = [String](repeating: "1", count: 26).joined()
                    transportCard = TransportCard(cardNumber: cardNumber)

                    let testCard = TransportCard.podorozhnikLong(number: cardNumber)

                    expect(transportCard).toNot(beNil())
                    expect(transportCard) == testCard
                }

                it("should remove non-numeric characters symbols from card number") {
                    cardNumber = [String](repeating: "1-", count: 11).joined()
                    transportCard = TransportCard(cardNumber: cardNumber)

                    let nonNumericRegex = "[^0-9]+"

                    expect(transportCard).toNot(beNil())
                    expect(transportCard.cardNumber).toNot(match(nonNumericRegex))
                }
            }

            context("type") {

                it("must be equal 1 for Podorozhnik Short transport card") {
                    transportCard = TransportCard.podorozhnikShort(number: "1")

                    expect(transportCard.cardType) == 1
                }

                it("must be equal 1 for Podorozhnik Long transport card") {
                    transportCard = TransportCard.podorozhnikLong(number: "1")

                    expect(transportCard.cardType) == 1
                }

                it("must be equal 2 for Sputnik transport card") {
                    transportCard = TransportCard.sputnik(number: "1")

                    expect(transportCard.cardType) == 2
                }
            }
        }
    }
}
