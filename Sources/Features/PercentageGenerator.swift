//
//  PercentageGenerator.swift
//  Features
//
//  Created by iainsmith on 31/03/2018.
//  Copyright © 2018 Features. All rights reserved.
//

import Foundation

enum RandomPercentageGenerator {
    static func generate() -> UInt {
        return UInt(arc4random_uniform(100) + 1)
    }
}
