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
            return UInt(integerForKey(NSUserDefaults.featurePercentageKey))
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
