//
//  features.swift
//  Features
//
//  Created by iainsmith on 03/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

public struct FeatureService {
    public static var fileName = "features"
    public static var bundle = NSBundle.mainBundle()
    public static var overRidePercentage: UInt? = nil
    public static var featureStore: FeatureStore = FeatureParser.loadFromDisk()
    public static var store: FeaturePercentageStore = NSUserDefaults.standardUserDefaults()

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
