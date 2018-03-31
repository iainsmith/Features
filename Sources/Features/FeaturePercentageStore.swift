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

extension UserDefaults: FeaturePercentageStore {
    private static let featurePercentageKey = "com.features.percentage"

    public var feature_storedPercentage: UInt? {
        get {
            let value = integer(forKey: (UserDefaults.featurePercentageKey))
            guard value != 0 else { return nil }
            return UInt(value)
        }

        set {
            let key = UserDefaults.featurePercentageKey

            if let value = newValue {
                set(Int(value), forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
