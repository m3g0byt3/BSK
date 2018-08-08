//
//  BSKSpec.swift
//  BSK_Example
//
//  Created by m3g0byt3 on 20/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
// swiftlint:disable function_body_length force_try force_unwrapping implicitly_unwrapped_optional

import Quick
import Nimble
import Moya
import Result
@testable import BSK

class BSKSpec: QuickSpec {

    override func spec() {

        // MARK: - Global properties

        var mockDelegate: BSKMockedDelegate!
        var adapter: BSKAdapter!
        var paymentCard: PaymentCard!
        var transportCard: TransportCard!
        var confirmationRequest: URLRequest!
        var processingRequest: URLRequest!
        let paymentIdentifier = UUID().uuidString
        let confirmationURLString = Constants.mbmBaseURL + Constants.mbmConfirmationPath + paymentIdentifier

        // MARK: - Suite setup / teardown

        let beforeClosure: BeforeExampleClosure = {
            mockDelegate = BSKMockedDelegate()
            adapter = BSKAdapter(delegate: mockDelegate!)
            paymentCard = PaymentCard(cardNumber: "1234 1234 1234 1234", cvv: "666", expiryMonth: 20, expiryYear: 20)
            transportCard = TransportCard(cardNumber: "12345678901")
            confirmationRequest = adapter.confirmationRequestForTransactionWith(id: paymentIdentifier, from: paymentCard)
            // Setup mocked Moya provider with 1 second delayed stub instead default
            adapter.provider = MoyaProvider<BSKProvider>(stubClosure: MoyaProvider.delayedStub(1),
                                                         manager: MoyaProvider<BSKProvider>.customAlamofireManager(),
                                                         trackInflights: true)
        }

        let afterClosure = {
            mockDelegate = nil
            adapter = nil
            paymentCard = nil
            transportCard = nil
            confirmationRequest = nil
            processingRequest = nil
        }

        describe("BSK adapter") {

            it("must set delegate when initialized") {
                let delegate = BSKMockedDelegate()
                let adapter = BSKAdapter(delegate: delegate)
                expect(adapter.delegate) === delegate
            }

            // MARK: - API calls, etc

            describe("process payment request") {

                beforeEach { beforeClosure() }
                afterEach { afterClosure() }

                it("should not allow more than one concurrent payment request") {
                    // initiate first request
                    adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                    // initiate second request
                    adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                    expect(mockDelegate.transactionError).toEventually(matchError(BSKError.busy), timeout: 5)
                }

                describe("should notify delegate about network errors") {

                    it("on ISPP backend") {
                        // Setup mocked Moya provider that will always fail with 404 error
                        let networkError = NSError(domain: "com.m3g0byt3.bsk", code: 404)
                        let expectedError = BSKError(networkError)
                        let endpointClosure: MoyaProvider<BSKProvider>.EndpointClosure = { target in
                            return Endpoint(url: URL(target: target).absoluteString,
                                            sampleResponseClosure: { .networkError(networkError) },
                                            method: target.method,
                                            task: target.task,
                                            httpHeaderFields: target.headers)
                        }

                        adapter.provider = MoyaProvider<BSKProvider>(endpointClosure: endpointClosure,
                                                                     stubClosure: MoyaProvider.delayedStub(1),
                                                                     manager: MoyaProvider<BSKProvider>.customAlamofireManager() ,
                                                                     trackInflights: true)

                        adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                        expect(mockDelegate.transactionError).toEventually(matchError(expectedError), timeout: 5)
                    }

                    it("on MBM backend") {
                        // Setup mocked Moya provider that will fail on `processPayment` target with 404 error
                        let networkError = NSError(domain: "com.m3g0byt3.bsk", code: 404)
                        let expectedError = BSKError(networkError)
                        let endpointClosure: MoyaProvider<BSKProvider>.EndpointClosure = { target in
                            switch target {
                            case .initiatePayment:
                                return MoyaProvider.defaultEndpointMapping(for: target)
                            case .processPayment:
                                return Endpoint(url: URL(target: target).absoluteString,
                                                sampleResponseClosure: { .networkError(networkError) },
                                                method: target.method,
                                                task: target.task,
                                                httpHeaderFields: target.headers)
                            }
                        }

                        adapter.provider = MoyaProvider<BSKProvider>(endpointClosure: endpointClosure,
                                                                     stubClosure: MoyaProvider.delayedStub(1),
                                                                     manager: MoyaProvider<BSKProvider>.customAlamofireManager() ,
                                                                     trackInflights: true)

                        adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                        expect(mockDelegate.transactionError).toEventually(matchError(expectedError), timeout: 5)
                    }
                }

                it("should provide confirmation request to the delegate") {
                    adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                    expect(mockDelegate.transactionRequest).toEventuallyNot(beNil(), timeout: 5)
                }

                it("should notify delegate about maintenance mode") {
                    // Setup mocked Moya provider that will always return maintenance mode response
                    let responseClosure: Endpoint.SampleResponseClosure = {
                        let responseString = Constants.BackendError.maintenanceMode
                            .appending(UUID().uuidString)
                        return EndpointSampleResponse.networkResponse(200, responseString.data(using: .utf8)!)
                    }

                    let endpointClosure: MoyaProvider<BSKProvider>.EndpointClosure = { target in
                        return Endpoint(url: URL(target: target).absoluteString,
                                        sampleResponseClosure: responseClosure,
                                        method: target.method,
                                        task: target.task,
                                        httpHeaderFields: target.headers)
                    }

                    adapter.provider = MoyaProvider<BSKProvider>(endpointClosure: endpointClosure,
                                                                 stubClosure: MoyaProvider.delayedStub(1),
                                                                 manager: MoyaProvider<BSKProvider>.customAlamofireManager(),
                                                                 trackInflights: true)

                    adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                    expect(mockDelegate.transactionError).toEventually(matchError(BSKError.maintenanceMode), timeout: 5)
                }

                it("should notify delegate about incorrect sum") {
                    adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 99_999)
                    expect(mockDelegate.transactionError).toEventually(matchError(BSKError.wrongSum), timeout: 5)
                }

                it("should notify delegate about incorrect card number") {
                    transportCard = TransportCard(cardNumber: "00000000000")!
                    adapter.topUpTransportCard(transportCard, from: paymentCard, amount: 1)
                    expect(mockDelegate.transactionError).toEventually(matchError(BSKError.wrongCardNumber), timeout: 5)
                }

                it("should send request and receive response from ISPP backend") {
                    waitUntil(timeout: 5) { done in
                        adapter.provider.request(.initiatePayment(transportCard: transportCard, amount: 1)) { response in
                            if case .success(let data) = response {
                                expect(data.data).toNot(beNil())
                            }
                            done()
                        }
                    }
                }

                it("should send request and receive response from MBM backend") {
                    waitUntil(timeout: 5) { done in
                        adapter.provider.request(.processPayment(sessionID: paymentIdentifier,
                                                                 transactionID: paymentIdentifier)) { response in
                            if case .success(let data) = response {
                                expect(data.data).toNot(beNil())
                            }
                            done()
                        }
                    }
                }
            }

            // MARK: - Payment response parsing

            describe("payment response parsing") {

                beforeEach { beforeClosure() }
                afterEach { afterClosure() }

                it("should detect maintenance mode") {
                    let response = Moya.Response(statusCode: 200,
                                                 data: Constants.BackendError.maintenanceMode.data(using: .utf8)!)
                    expect { try adapter.parseResponse(response) }.to(throwError(BSKError.maintenanceMode))
                }

                it("should detect wrong sum") {
                    let response = Moya.Response(statusCode: 200,
                                                 data: Constants.BackendError.wrongSum.data(using: .utf8)!)
                    expect { try adapter.parseResponse(response) }.to(throwError(BSKError.wrongSum))
                }

                it("should detect wrong card number") {
                    let response = Moya.Response(statusCode: 200,
                                                 data: Constants.BackendError.wrongCardNumber.data(using: .utf8)!)
                    expect { try adapter.parseResponse(response) }.to(throwError(BSKError.wrongCardNumber))
                }

                it("should detect incorrect response") {
                    let response = Moya.Response(statusCode: 200, data: Data())
                    expect { try adapter.parseResponse(response) }.to(throwError(BSKError.parseError))
                }

                it("should return session and transaction IDs") {
                    let sessionID = UUID().uuidString
                    let transactionID = UUID().uuidString
                    let url = URL(string: Constants.mbmBaseURL)!
                        .appendingPathComponent(sessionID)
                        .appendingPathComponent(transactionID)
                    let response = Moya.Response(statusCode: 200, data: url.absoluteString.data(using: .utf8)!)
                    let parsedIDs = try! adapter.parseResponse(response)

                    expect(parsedIDs.sessionID) == sessionID
                    expect(parsedIDs.transactionID) == transactionID
                }
            }

            // MARK: - Confirmation request creation

            describe("new confirmation request") {

                beforeEach { beforeClosure() }
                afterEach { afterClosure() }

                it("should be not nil") {
                    expect(confirmationRequest).toNot(beNil())
                }

                it("should be HTTP POST") {
                    expect(confirmationRequest?.httpMethod).to(match("(?i)POST"))
                }

                it("should use correct URL") {
                    expect(confirmationRequest?.url?.absoluteString) == confirmationURLString
                }

                it("should contain correct HTTP headers") {
                    expect(confirmationRequest?.allHTTPHeaderFields) == Constants.headers
                }

                it("should contain correct HTTP body") {
                    let bundle = Bundle(for: type(of: self))
                    let path = bundle.path(forResource: "ConfirmationRequestHTTPBody", ofType: "txt")
                    let data = path.map { URL(fileURLWithPath: $0) }.flatMap { try? Data(contentsOf: $0) }

                    expect(confirmationRequest.httpBody) == data
                }
            }

            // MARK: - Delegate's requests processing

            describe("process delegate's requests") {

                beforeEach { beforeClosure() }
                afterEach { afterClosure() }

                it("should ignore irrelevant URLs") {
                    let url = URL(string: "about:blank")
                    processingRequest = URLRequest(url: url!)

                    adapter.processConfirmationRequest(processingRequest)

                    expect(mockDelegate.transactionCompleted).toEventually(beFalse())
                    expect(mockDelegate.transactionError).toEventually(beNil())
                    expect(mockDelegate.transactionRequest).toEventually(beNil())
                }

                it("should notify delegate if transaction failed with error") {
                    let url = URL(string: Constants.isppBaseURL)?.appendingPathComponent("fail")
                    processingRequest = URLRequest(url: url!)

                    adapter.processConfirmationRequest(processingRequest)
                    expect(mockDelegate.transactionError).toEventually(matchError(BSKError.topUpError), timeout: 5)
                }

                it("should notify delegate if transaction completed") {
                    let url = URL(string: Constants.isppBaseURL)
                    processingRequest = URLRequest(url: url!)

                    adapter.processConfirmationRequest(processingRequest)
                    expect(mockDelegate.transactionCompleted).toEventually(beTrue(), timeout: 5)
                }
            }
        }
    }
}
