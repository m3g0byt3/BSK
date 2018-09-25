//
//  BSKTransportCardSpec.swift
//  BSK_Example
//
//  Created by m3g0byt3 on 20/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
// swiftlint:disable force_unwrapping

import Foundation
import Quick
import Nimble
@testable import BSK

final class BSKTransportCardSpec: QuickSpec {

    override func spec() {

        describe("TransportCard") {

            // MARK: - Properties

            let nonNumericRegex = "[^0-9]+"

            // MARK: - Tests

            context("initialization") {

                it("from 11-digit number should return Sputnik transport card") {
                    let cardNumber = String(randomWithLengthWithin: 11..<12)
                    let testCard = BSKTransportCard.sputnik(number: cardNumber)
                    let transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard) == testCard
                }

                it("from 19-digit number should return Podorozhnik Short transport card") {
                    let cardNumber = String(randomWithLengthWithin: 19..<20)
                    let testCard = BSKTransportCard.podorozhnikShort(number: cardNumber)
                    let transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard) == testCard
                }

                it("from 26-digit number should return Podorozhnik Long transport card") {
                    let cardNumber = String(randomWithLengthWithin: 26..<27)
                    let testCard = BSKTransportCard.podorozhnikLong(number: cardNumber)
                    let transportCard = BSKTransportCard(cardNumber: cardNumber)

                    expect(transportCard) == testCard
                }

                it("should remove non-numeric characters symbols from card number") {
                    let cardNumber = String(randomWithLengthWithin: 11..<12)
                    let transportCard = BSKTransportCard(cardNumber: cardNumber)!

                    expect(transportCard.cardNumber).toNot(match(nonNumericRegex))
                }
            }

            context("cardType value") {

                it("must be equal 1 for Podorozhnik Short transport card") {
                    let transportCard = BSKTransportCard.podorozhnikShort(number: "")

                    expect(transportCard.cardType) == 1
                }

                it("must be equal 1 for Podorozhnik Long transport card") {
                    let transportCard = BSKTransportCard.podorozhnikLong(number: "")

                    expect(transportCard.cardType) == 1
                }

                it("must be equal 2 for Sputnik transport card") {
                    let transportCard = BSKTransportCard.sputnik(number: "")

                    expect(transportCard.cardType) == 2
                }
            }
        }
    }
}
