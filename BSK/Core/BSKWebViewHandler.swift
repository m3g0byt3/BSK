//
//  BSKWebViewHandler.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//
// swiftlint:disable implicitly_unwrapped_optional

import Foundation
import WebKit

class BSKWebViewHandler: NSObject, BSKWebViewHandlerProtocol, _BSKWebViewHandlerProtocol {

    // MARK: - BSKWebViewHandlerControlProtocol protocol conformance

    var paymentCompletedSuccessfully: CompletionCallback?
    var handler: BSKWebViewHandlerProtocol { return self }

    // MARK: - Initialization

    deinit {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

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

// MARK: - UIWebViewDelegate protocol conformance

extension BSKWebViewHandler {

    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {

        handleRequest(request)

        return true
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - WKNavigationDelegate protocol conformance

extension BSKWebViewHandler {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        handleRequest(navigationAction.request)

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
