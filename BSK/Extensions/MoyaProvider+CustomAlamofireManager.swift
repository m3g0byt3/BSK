//
//  MoyaProvider+CustomAlamofireManager.swift
//  BSK
//
//  Created by m3g0byt3 on 01/11/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation
import Moya

public extension MoyaProvider {
    /**
     * Class method that returns customized instance of Alamofire default manager
     * - returns: Customized instance of Alamofire default manager
     */
    public final class func customAlamofireManager() -> Manager {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        return manager
    }
}
