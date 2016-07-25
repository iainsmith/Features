//
//  features.swift
//  Features
//
//  Created by iainsmith on 03/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

public typealias FeatureData = (name: String, active: Bool)

public struct FeatureService {
    public static var fileName = "features"
    public static var bundle = NSBundle.mainBundle()
    public static var overRidePercentage: UInt? = nil
    public static var featureStore: FeatureStore = FeatureParser.loadFromDisk()
    public static var store: FeaturePercentageStore = NSUserDefaults.standardUserDefaults()

    public static func featureDetails() -> [FeatureData] {
        return featureStore.features.map { feature in
            let name = feature.name
            let active = featureStore.isActive(name)
            return (name: name, active: active)
        }
    }

    public static func updatePercentage(percentage: UInt) {
        store.feature_storedPercentage = percentage
        featureStore = FeatureStore(features: featureStore.features, devicePercentage: percentage)
    }

    internal static func percentage() -> UInt {
       return overRidePercentage ?? existingPercentage() ?? generatedSavedPercentage()
    }

    private static func existingPercentage() -> UInt? {
        return store.feature_storedPercentage
    }

    private static func generatedSavedPercentage() -> UInt {
        let percentage = RandomPercentageGenerator.generate()
        store.feature_storedPercentage = percentage
        return percentage
    }
}

internal struct RandomPercentageGenerator {
    static func generate() -> UInt {
        return UInt(arc4random_uniform(100) + 1)
    }
}
