//
//  BSKAdapterSpec.swift
//  BSK_UnitTests
//
//  Created by m3g0byt3 on 25/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Moya
import Quick
import Nimble
@testable import BSK

final class BSKAdapterSpec: QuickSpec {

    override func spec() {

        describe("BSKAdapter") {

            // MARK: - Properties

            var mockedDelegate: BSKMockedDelegate!
            var adapter: BSKAdapter!
            // Default mocked provider
            let provider = MoyaProvider<BSKProvider>(stubClosure: MoyaProvider.delayedStub(1),
                                                     manager: MoyaProvider<BSKProvider>.customAlamofireManager(),
                                                     trackInflights: true)
            let transportCard = BSKTransportCard(cardNumber: String.randomNumberStringWithLength(within: 11..<12))!
            let paymentCard = BSKPaymentMethod.CreditCard(cardNumber: String.randomNumberStringWithLength(within: 16..<17),
                                                          expiryMonth: 12,
                                                          expiryYear: 99)!
            let paymentType = BSKPaymentType.creditCard(paymentCard)

            // MARK: - Setup/Teardown

            beforeEach {
                mockedDelegate = BSKMockedDelegate()
                adapter = BSKAdapter(delegate: mockedDelegate, providerPlugins: [])
                adapter.provider = provider
            }

            afterEach {
                mockedDelegate = nil
                adapter = nil
            }

            // MARK: - Tests

            context("initialization") {

                it("Should set delegate") {
                    expect(adapter.delegate) === mockedDelegate
                }

                it("Should have request handler") {
                    expect(adapter.webViewHandler).to(beAKindOf(BSKWebViewHandlerProtocol.self))
                }
            }

            context("payment request") {

                it("should not allow more than one concurrent payment request") {
                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 1)
                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 1)

                    expect(mockedDelegate.transactionError).toEventually(matchError(BSKError.busy))
                }

                it("should notify delegate about network errors") {
                    // Setup mocked provider that always returns network error (Like no connection available)
                    let error = NSError(domain: "com.m3g0byt3.BSK", code: -1)
                    let expectedError = BSKError.underlying(error)
                    let endpointClosure = { (target: BSKProvider) -> Endpoint in
                        return Endpoint(url: URL(target: target).absoluteString,
                                        sampleResponseClosure: { .networkError(error) },
                                        method: target.method,
                                        task: target.task,
                                        httpHeaderFields: target.headers)
                    }

                    adapter.provider = MoyaProvider<BSKProvider>(endpointClosure: endpointClosure)

                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 1)

                    expect(mockedDelegate.transactionError).toEventually(matchError(expectedError))
                }

                it("should notify delegate about backend errors") {
                    // Setup mocked provider that always returns backend error (like 404 Not Found)
                    let endpointClosure = { (target: BSKProvider) -> Endpoint in
                        return Endpoint(url: URL(target: target).absoluteString,
                                        sampleResponseClosure: { .networkResponse(404, Data()) },
                                        method: target.method,
                                        task: target.task,
                                        httpHeaderFields: target.headers)
                    }

                    adapter.provider = MoyaProvider<BSKProvider>(endpointClosure: endpointClosure,
                                                                 stubClosure: MoyaProvider.delayedStub(1))
                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 1)

                    expect(mockedDelegate.transactionError).toEventuallyNot(beNil())
                }


                it("should provide confirmation request to the delegate") {
                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 1)

                    expect(mockedDelegate.transactionRequest).toEventuallyNot(beNil(), timeout: 5)
                }

                it("should notify delegate about maintenance mode") {
                    // Setup mocked provider that always returns maintenance mode response
                    let responseClosure = { () -> EndpointSampleResponse in
                        let responseString = Constants.BackendError.maintenanceMode.appending(UUID().uuidString)
                        return EndpointSampleResponse.networkResponse(200, responseString.data(using: .utf8)!)
                    }

                    let endpointClosure = { (target: BSKProvider) -> Endpoint in
                        return Endpoint(url: URL(target: target).absoluteString,
                                        sampleResponseClosure: responseClosure,
                                        method: target.method,
                                        task: target.task,
                                        httpHeaderFields: target.headers)
                    }

                    adapter.provider = MoyaProvider<BSKProvider>(endpointClosure: endpointClosure,
                                                                 stubClosure: MoyaProvider.delayedStub(1))

                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 1)

                    expect(mockedDelegate.transactionError).toEventually(matchError(BSKError.maintenanceMode), timeout: 5)
                }

                it("should notify delegate about incorrect sum") {
                    adapter.topUpTransportCard(transportCard, from: paymentType, amount: 99_999)
                    expect(mockedDelegate.transactionError).toEventually(matchError(BSKError.wrongSum), timeout: 5)
                }

                it("should notify delegate about incorrect card number") {
                    let testTransportCard = BSKTransportCard(cardNumber: "00000000000")
                    adapter.topUpTransportCard(testTransportCard!, from: paymentType, amount: 1)

                    expect(mockedDelegate.transactionError).toEventually(matchError(BSKError.wrongCardNumber), timeout: 5)
                }
            }
        }
    }
}
