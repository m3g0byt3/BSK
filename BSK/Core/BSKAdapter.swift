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

public struct BSKAdapter {
    
    //MARK: - Public API
    /// BSKTransactionDelegate delegate
    public weak var delegate: BSKTransactionDelegate?
    
    /// Public init with delegate
    public init(delegate: BSKTransactionDelegate) {
        self.delegate = delegate
        self.provider = MoyaProvider<BSKProvider>(manager: MoyaProvider<BSKProvider>.customAlamofireManager(), trackInflights: true)
    }
    
    /**
     * Public method to initiate payment
     * - parameter transportCard: Transport card object
     * - parameter paymentCard: Payment card object
     * - parameter amount: Amount to top up
     */
    public func topUpTransportCard(_ transportCard: TransportCard, from paymentCard: PaymentCard, amount: Decimal) {
        guard provider.inflightRequests.isEmpty else {
            self.delegate?.transactionDidFailWithError(BSKError.busy)
            return
        }
        // initiate request to `httр://ispp.spbmetropoliten.ru`
        provider.request(.initiatePayment(transportCard: transportCard, amount: amount)) { result in
            // processing response from `httр://ispp.spbmetropoliten.ru`
            switch result {
                
            case .success(let response):
                do {
                    // trying to parse response from `httр://ispp.spbmetropoliten.ru`
                    let parsedResponse = try self.parseResponse(response)
                    // initiate request to `httрs://mobi-money.ru`
                    self.provider.request(.processPayment(sessionID: parsedResponse.0, transactionID: parsedResponse.1)) { result in
                        // processing response from `httрs://mobi-money.ru`
                        switch result {
                            
                        case .success:
                            if let request = self.confirmationRequestForTransactionWith(id: parsedResponse.1, from: paymentCard) {
                                self.delegate?.didReceiveConfirmationRequest(request)
                            } else {
                                self.delegate?.transactionDidFailWithError(BSKError.parseError)
                            }
                            
                        case .failure(let networkError):
                            self.delegate?.transactionDidFailWithError(BSKError(networkError))
                        }
                    }
                } catch {
                    self.delegate?.transactionDidFailWithError(error as! BSKError)
                }
                
            case .failure(let networkError):
                self.delegate?.transactionDidFailWithError(BSKError(networkError))
            }
        }
    }
    
    /**
     * Parse and process web URLs loaded by the delegate (e.g. in UIWebView / SFSafariViewController)
     * - parameter url: URL to parse
     */
    public func processConfirmationRequest(_ request: URLRequest) {
        let failRegex = "fail"
        
        guard let paymentURL = request.url else {
            delegate?.transactionDidFailWithError(BSKError.parseError)
            return
        }
        
        guard paymentURL.absoluteString.contains(Constants.isppBaseURL) else { return }
        
        if paymentURL.pathComponents.contains(failRegex) {
            delegate?.transactionDidFailWithError(BSKError.topUpError)
        } else {
            delegate?.transactionDidComplete()
        }
    }
    
    //MARK: - Private API
    
    /// Internal Moya provider, not a constant because may be replaced with mock in unit tests
    var provider: MoyaProvider<BSKProvider>
    
    /**
     * Parse transaction response from http://ispp.spbmetropoliten.ru, returns sessionID and transactionID for transaction
     * - parameter response: Transaction response from http://ispp.spbmetropoliten.ru
     * - returns: Tuple with `sessionID` and `transactionID` for current transaction
     * - throws: Appropriate `BSKError` when no data received, something wrong on the back-end or unable to parse response
     */
    func parseResponse(_ response: Moya.Response) throws -> (sessionID: String, transactionID: String) {
        let separator: Character = "\""
        
        guard let responseString = String(data: response.data, encoding: .utf8) else {
            throw BSKError.parseError
        }
        
        guard !responseString.contains(Constants.BackendError.maintenanceMode) else {
            throw BSKError.maintenanceMode
        }
        
        guard !responseString.contains(Constants.BackendError.wrongSum) else {
            throw BSKError.wrongSum
        }
        
        guard !responseString.contains(Constants.BackendError.wrongCardNumber) else {
            throw BSKError.wrongCardNumber
        }
        
        let paymentURLString = responseString.split(separator: separator).first { $0.contains(Constants.mbmBaseURL) }
        
        guard let paymentURL = paymentURLString.map({ String($0) }).flatMap({ URL(string: $0) }) else {
            throw BSKError.parseError
        }
        
        let sessionID = paymentURL.deletingLastPathComponent().lastPathComponent
        let transactionID = paymentURL.lastPathComponent
        
        return (sessionID, transactionID)
    }
    
    /**
     * Private method to confirm payment on https://mobi-money.ru
     * - parameter transactionID: `Payment ID` (last path component of the URL created on http://ispp.spbmetropoliten.ru)
     * - returns: Optional URLRequest for 3DS confirmation that should be loaded
     *   by the delegate (e.g. in UIWebView / SFSafariViewController)
     */
    func confirmationRequestForTransactionWith(id transactionID: String, from card: PaymentCard) -> URLRequest? {
        /**
         * Internal method for creation HTTP body based on provided payment card information
         * - parameter card: Payment card information
         * - returns: HTTP body as string
         */
        func httpBodyFromPaymentCard(_ card: PaymentCard) -> String {
            return ["CardDataInputForm%5Bpan%5D=\(card.cardNumber!)",
                "CardDataInputForm%5Bcvv2%5D=\(card.cvv!)",
                "CardDataInputForm%5Bmonth%5D=\(card.expiryMonth!)",
                "CardDataInputForm%5Byear%5D=\(card.expiryYear!)",
                "CardDataInputForm%5Bholder%5D=Card Holder",
                "CardDataInputForm%5Bphone%5D=79990000000"].joined(separator: "&")
        }
        
        let url = URL(string: Constants.mbmBaseURL)!
            .appendingPathComponent(Constants.mbmConfirmationPath)
            .appendingPathComponent(transactionID)
        
        var request = try? URLRequest(url: url, method: .post, headers: Constants.headers)
        
        request?.httpBody = httpBodyFromPaymentCard(card).data(using: .utf8)
        request?.timeoutInterval = 15
        request?.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        return request
    }
}
