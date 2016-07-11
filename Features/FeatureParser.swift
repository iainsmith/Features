//
//  FeatureParser.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

internal struct FeatureParser {
    static func loadFromDisk(percentage percentage: UInt = FeatureService.percentage(), bundle: NSBundle = FeatureService.bundle, fileName: String = FeatureService.fileName) -> FeatureStore {
        let path = bundle.pathForResource(fileName, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let featuresJSON: Array<Dictionary<String, AnyObject>> = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! Array<Dictionary<String, AnyObject>>

        let features = featuresJSON.flatMap { feature -> Feature? in
            FeatureParser.dictionaryToFeature(feature)
        }

        return FeatureStore(features: features, devicePercentage: percentage)
    }

    private static func dictionaryToFeature(dictionary: Dictionary<String, AnyObject>) -> Feature? {
        let percentageKey = "percentage"
        let platformKey = "platforms"
        let nameKey = "name"
        let activeKey = "active"

        var lowerCaseDictionary = dictionary
        lowerCaseDictionary.lowercaseKeys()
        guard let name = lowerCaseDictionary[nameKey] as? String, let active = lowerCaseDictionary[activeKey] as? Bool else {
            return nil
        }

        let percentage: UInt
        if active {
            percentage = lowerCaseDictionary[percentageKey] as? UInt ?? 100
        } else {
            percentage = 0
        }

        var platform = Platform.All
        if let userPlatformString = lowerCaseDictionary[platformKey] as? String, userPlatform = Platform.platFormFromJSONString(userPlatformString) {
            platform = userPlatform
        }

        return Feature(name: name, rolloutPercentage: percentage, platforms: platform, active: active)
    }
}
