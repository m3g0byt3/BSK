//
//  MoyaProvider+Extensions.swift
//  BSK
//
//  Created by m3g0byt3 on 01/11/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation
import Moya
import Alamofire

/// Provides custom AlamofireManager
public extension MoyaProvider {

    private typealias Policies = [String: ServerTrustPolicy]

    /// Class method that returns customized instance of Alamofire default manager
    /// - returns: Customized instance of Alamofire default manager
    public final class func customAlamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        let policies: Policies = [Constants.isppHostname: .disableEvaluation ]
        let policyManager = ServerTrustPolicyManager(policies: policies)
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let manager = Manager(configuration: configuration, serverTrustPolicyManager: policyManager)
        manager.startRequestsImmediately = false

        return manager
    }
}
