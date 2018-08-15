//
//  BSKAdapter.swift
//  BSK
//
//  Created by m3g0byt3 on 30/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation
import Moya
import Result

/// Network adapter for performing payment requests
public final class BSKAdapter {

    // MARK: - Private properties

    /// Internal Moya provider, not a constant because may be replaced with mock in unit tests
    var provider: MoyaProvider<BSKProvider>

    /// Internal handler for URL requests loaded by the `UIWebView`/`SFSafariViewController` instance.
    var handler: _BSKWebViewHandlerProtocol

    // MARK: - Public properties

    /// BSKTransactionDelegate delegate
    public weak var delegate: BSKTransactionDelegate?

    /// Handler for URL requests loaded by the `UIWebView`/`SFSafariViewController` instance.
    public var webViewHandler: BSKWebViewHandlerProtocol { return handler.handler }

    // MARK: - Initialization

    /// Public init with delegate
    public init(delegate: BSKTransactionDelegate? = nil) {
        self.delegate = delegate
        self.provider = MoyaProvider<BSKProvider>(manager: MoyaProvider<BSKProvider>.customAlamofireManager(), trackInflights: true)
        self.handler = BSKWebViewHandler()
        self.handler.paymentCompletedSuccessfully = { [weak self] status in
            if status {
                self?.delegate?.transactionDidComplete()
            } else {
                self?.delegate?.transactionDidFailWithError(.unableToTopUp)
            }
        }
    }

    // MARK: - Public API

    /// Public method to perform payment.
    /// - parameters:
    ///     - transportCard: Transport card object
    ///     - payment: Type of payment
    ///     - amount: Amount to top up
    public func topUpTransportCard(_ transportCard: BSKTransportCard, from payment: BSKPaymentType, amount: Int) {
        // Currently only credit cards supported as a payment method
        guard case .creditCard(let .some(paymentCard)) = payment else {
            delegate?.transactionDidFailWithError(.paymentMethodNotSupported)
            return
        }

        // Allow only one active request at a time
        guard provider.inflightRequests.isEmpty else {
            delegate?.transactionDidFailWithError(.busy)
            return
        }

        // Initiate request to `httрs://ispp.spbmetropoliten.ru`
        provider.request(.initiatePayment(transportCard: transportCard, amount: amount)) { [weak self] result in
            switch result {

            case .success(let response):
                do {
                    let responseISPP = try response
                        .filterSuccessfulStatusCodes()
                        .map(BSKResponseISPP.self)

                    // Initiate request to `httрs://mobi-money.ru`
                    self?.provider.request(.processPayment(paymentRequest: responseISPP)) { result in
                        switch result {

                        case .success(let response):
                            do {
                                _ = try response.filterSuccessfulStatusCodes()
                                let responseMBM = try BSKResponseMBM(transactionID: responseISPP.transactionID,
                                                                     paymentCard: paymentCard)
                                self?.delegate?.didReceiveConfirmationRequest(responseMBM.request)
                            } catch let error as BSKError {
                                self?.delegate?.transactionDidFailWithError(error)
                            } catch {
                                self?.delegate?.transactionDidFailWithError(.underlying(error))
                            }

                        case .failure(let error):
                            self?.delegate?.transactionDidFailWithError(.underlying(error))
                        }
                    }
                } catch let error as BSKError {
                    self?.delegate?.transactionDidFailWithError(error)
                } catch {
                    self?.delegate?.transactionDidFailWithError(.underlying(error))
                }

            case .failure(let error):
                self?.delegate?.transactionDidFailWithError(.underlying(error))
            }
        }
    }
}
