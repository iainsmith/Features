//
//  FeatureStore.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

public protocol FeaturePercentageStore {
    var feature_storedPercentage: UInt? { get set }
}

extension NSUserDefaults: FeaturePercentageStore {
    private static let featurePercentageKey = "com.features.percentage"

    public var feature_storedPercentage: UInt? {
        get {
            let value = integerForKey(NSUserDefaults.featurePercentageKey)
            guard value != 0 else { return nil }
            return UInt(value)
        }

        set {
            let key = NSUserDefaults.featurePercentageKey

            if let value = newValue {
                setInteger(Int(value), forKey: key)
            } else {
                removeObjectForKey(key)
            }
        }
    }
}
