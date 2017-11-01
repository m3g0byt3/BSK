//
//  Constants.swift
//  BSK
//
//  Created by m3g0byt3 on 30/10/2017.
//  Copyright © 2017 m3g0byt3. All rights reserved.
//

import Foundation

/// Various constant parameters for network requests, etc
struct Constants {
    /// Base URL for `httр://ispp.spbmetropoliten.ru`
    static let isppBaseURL = "http://ispp.spbmetropoliten.ru"
    /// Base URL for `httрs://mobi-money.ru`
    static let mbmBaseURL = "https://cps.mobi-money.ru"
    /// Path for `httр://ispp.spbmetropoliten.ru`
    static let isppPath = ""
    /// Payment path for `httрs://mobi-money.ru`
    static let mbmProcessingPath = "/pay/start/"
     /// Confirmation path for `httрs://mobi-money.ru`
    static let mbmConfirmationPath = "/pay/confirm/"
    /// Default HTTP request headers
    static let headers = ["Upgrade-Insecure-Requests": "1",
                          "Content-Type": "application/x-www-form-urlencoded",
                          "Cache-Control": "max-age=0",
                          "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.0 Mobile/14G60 Safari/602.1"]
    
    /// Represents parameters of an initial payment HTTP request to `httр://ispp.spbmetropoliten.ru`
    struct RequestParameters {
        static let numberParameterName = "card_id"
        static let cardTypeParameterName = "cardtype"
        static let paymentTypeParameterName = "paytype"
        static let sumParameterName = "sum"
        static let phoneParameterName = "phone"
        
        @available(*, unavailable) init() {}
    }
    
    /// Represents various errors on the back-end
    struct BackendError {
        static let maintenanceMode = "profilactika"
        static let wrongCardNumber = "text bsk error"
        static let wrongSum = "summ error"
        
        @available(*, unavailable) init() {}
    }
    
    @available(*, unavailable) init() {}
}
