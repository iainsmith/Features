//
//  FeatureParser.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

typealias FeatureJSON = Array<Dictionary<String, AnyObject>>

internal struct FeatureParser {
    static func loadFromDisk(percentage percentage: UInt = FeatureService.devicePercentage(), bundle: NSBundle = FeatureService.bundle, fileName: String = FeatureService.fileName) -> FeatureStore {
        let path = bundle.pathForResource(fileName, ofType: "json")!
        return loadFromPath(path, percentage: percentage)!
    }

    static func loadFromPath(path: String, percentage: UInt = FeatureService.devicePercentage(), strict: Bool = false) -> FeatureStore? {
        guard let data = NSData(contentsOfFile: path) else { return nil }
        let result = loadFromData(data, percentage: percentage, strict: strict)
        switch result {
        case .Success(let store, _):
            return store
        case .Failure:
            return nil
        }
    }

    static func loadFromData(data: NSData, percentage: UInt = FeatureService.devicePercentage(), strict: Bool) -> FeatureResult<(FeatureStore, NSData)> {
        do {
            if let featuresJSON: Array<Dictionary<String, AnyObject>> = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? Array<Dictionary<String, AnyObject>> {

                let features = featuresJSON.flatMap { feature -> Feature? in
                    FeatureParser.dictionaryToFeature(feature)
                }

                if strict == false || featuresJSON.count == features.count {
                    let store = FeatureStore(features: features, devicePercentage: percentage)
                    return .Success(store, data)
                } else {
                    return .Failure()
                }

            } else {
                return .Failure()
            }
        } catch {
            return .Failure()
        }
    }

    static func dictionaryToFeature(dictionary: Dictionary<String, AnyObject>) -> Feature? {
        let percentageKey = "percentage"
        let platformKey = "platforms"
        let nameKey = "name"
        let activeKey = "active"
        let sectionKey = "section"

        var lowerCaseDictionary = dictionary
        lowerCaseDictionary.lowercaseKeys()
        guard let name = lowerCaseDictionary[nameKey] as? String, let active = lowerCaseDictionary[activeKey] as? Bool else {
            return nil
        }

        let rolloutPercentage: UInt?
        if active {
            rolloutPercentage = lowerCaseDictionary[percentageKey] as? UInt ?? 100
        } else {
            rolloutPercentage = nil
        }

        var platform = Platform.All
        if let userPlatformString = lowerCaseDictionary[platformKey] as? String, userPlatform = Platform.platFormFromJSONString(userPlatformString) {
            platform = userPlatform
        }

        var section = Section.None
        if let sectionName = lowerCaseDictionary[sectionKey] as? String {
            section = .Some(name: sectionName)
        }

        return Feature(name: name, rolloutPercentage: rolloutPercentage, platforms: platform, section: section, active: active)
    }
}
