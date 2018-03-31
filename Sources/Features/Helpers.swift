//
//  Helpers.swift
//  Features
//
//  Created by iainsmith on 31/03/2018.
//  Copyright © 2018 Features. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringProtocol {
    mutating func lowercaseKeys() {
        for key in self.keys {
            self[String(key).lowercased() as! Key] = self.removeValue(forKey: key)
        }
    }
}
