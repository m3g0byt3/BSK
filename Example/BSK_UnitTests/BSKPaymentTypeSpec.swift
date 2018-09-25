//
//  BSKPaymentTypeSpec.swift
//  BSK_UnitTests
//
//  Created by m3g0byt3 on 25/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import BSK

final class BSKPaymentTypeSpec: QuickSpec {

    override func spec() {

        describe("PaymentMethod") {

            context("CreditCard") {

                it("raw value should be equal to 6") {
                    let paymentMethod = BSKPaymentType.creditCard(nil)

                    expect(paymentMethod.rawValue) == 6
                }
            }
        }
    }
}
