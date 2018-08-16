//
//  BSKWebViewHandler.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//

import Foundation
import WebKit

class BSKWebViewHandler: NSObject, BSKWebViewHandlerProtocol, _BSKWebViewHandlerProtocol {

    // MARK: - BSKWebViewHandlerControlProtocol protocol conformance

    var paymentCompletedSuccessfully: CompletionCallback?
    var handler: BSKWebViewHandlerProtocol { return self }

    // MARK: - Private API

    /// Process web URLs loaded by the `UIWebView`/`SFSafariViewController` instance.
    /// - parameter request: URLRequest to process
    private func handleRequest(_ request: URLRequest) {
        // Extract URL from request
        guard let url = request.url else { return }

        // Ignore irrelevant URL
        guard url.absoluteString.contains(Constants.isppHostname) else { return }

        // Check if payment was successful or not
        if url.pathComponents.contains(Constants.isppFailPathComponent) {
            paymentCompletedSuccessfully?(false)
        } else {
            paymentCompletedSuccessfully?(true)
        }
    }
}

// MARK: - BSKWebViewHandlerProtocol protocol conformance

extension BSKWebViewHandler {

    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {

        handleRequest(request)

        return true
    }
}

// MARK: - UIWebViewDelegate protocol conformance

extension BSKWebViewHandler {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        handleRequest(navigationAction.request)

        decisionHandler(.allow)
    }
}
