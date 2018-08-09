//
//  BSKWebViewHandlerProtocol.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//

import Foundation
import UIKit
import WebKit

/// Handles 3DS confirmation requests loaded by the WebView.
public typealias BSKWebViewHandlerProtocol = UIWebViewDelegate & WKNavigationDelegate

protocol _BSKWebViewHandlerProtocol {

    typealias CompletionCallback = (_ flag: Bool) -> Void

    var paymentCompletedSuccessfully: CompletionCallback? { get set }

    var handler: BSKWebViewHandlerProtocol { get }
}
