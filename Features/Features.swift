//
//  Features.swift
//  Features
//
//  Created by iainsmith on 03/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringLiteralConvertible {
    mutating func lowercaseKeys() {
        for key in self.keys {
            self[String(key).lowercaseString as! Key] = self.removeValueForKey(key)
        }
    }
}

public class FeatureName: NSObject, RawRepresentable {
    public let rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public func ==(lhs: FeatureName, rhs: FeatureName) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

            }
        }
    }
}

public struct Feature {
    let name: String
    let rolloutPercentage: UInt
    let platforms: Platform
    var active: Bool
}

public func == (lhs: Feature, rhs: Feature) -> Bool {
    return lhs.name == rhs.name && lhs.active == rhs.active && rhs.rolloutPercentage == rhs.rolloutPercentage && lhs.platforms == rhs.platforms
}

extension Feature: Equatable { }

public struct FeatureStore {
    var features: [Feature]
    let devicePercentage: UInt // Needs to be persisted across runs
    let currentPlatform: Platform

    init(features: [Feature], devicePercentage: UInt) {
        self.features = features
        self.devicePercentage = devicePercentage
        self.currentPlatform = Platform.currentDevice()
    }

    public func isEnabled(featureName: FeatureName) -> Bool {
        return featureEnabled(featureName.rawValue)
    }

    private func featureEnabled(name: String) -> Bool {
        let index = features.indexOf { feature -> Bool in
            feature.name == name
        }

        if let index = index {
            let feature = features[index]
            let activeForUser = (devicePercentage <= feature.rolloutPercentage)
            let activePlatform = feature.platforms.contains(currentPlatform)

            return feature.active && activeForUser && activePlatform
        }

        return false
    }

    mutating func updateFeature(feature: Feature) {
        let index = features.indexOf { $0.name == feature.name }

        if let index = index {
            features[index] = feature
        } else {
            features.append(feature)
        }
    }
}

public func featureEnabeld(feature: FeatureName) -> Bool {
    return FeatureService.featureStore.isEnabled(feature)
}

extension FeatureStore: CustomDebugStringConvertible {
    public var debugDescription: String {
        return features.debugDescription
    }
}
