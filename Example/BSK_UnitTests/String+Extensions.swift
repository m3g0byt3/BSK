//
//  String+Extensions.swift
//  BSK_UnitTests
//
//  Created by m3g0byt3 on 25/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension String {

    static func randomNumberStringWithLength(within range: Range<Int>) -> String {
        let lowerBound = UInt32(range.lowerBound)
        let maxUpperBound = UInt32(range.upperBound)
        let randomUpperBound = arc4random_uniform(maxUpperBound - lowerBound) + lowerBound
        return [() -> String](repeating: { "\(arc4random_uniform(10))" }, count: Int(randomUpperBound))
            .map { $0() }
            .joined()
    }
}
