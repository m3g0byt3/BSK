//
//  MoyaResponse+Extensions.swift
//  Alamofire
//
//  Created by m3g0byt3 on 08/08/2018.
//

import Foundation
import Moya

extension Moya.Response {

    func map<T: BSKMappable>(_ type: T.Type) throws -> T {
        return try type.init(data)
    }
}
