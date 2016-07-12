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

public enum Section {
    case None
    case Some(name: String)

    var name: String {
        get {
            switch self {
            case .None:
                return "no section"
            case .Some(let name):
                return name
            }
        }
    }
}

public struct Feature {
    public let name: String
    public let rolloutPercentage: UInt
    internal let platforms: Platform
    public let section: Section
    public var active: Bool
}

public func == (lhs: Feature, rhs: Feature) -> Bool {
    return lhs.name == rhs.name && lhs.active == rhs.active && rhs.rolloutPercentage == rhs.rolloutPercentage && lhs.platforms == rhs.platforms
}

extension Feature: Equatable { }

public struct FeatureStore {
    var features: [Feature]
    var devicePercentage: UInt
    let currentPlatform: Platform

    init(features: [Feature], devicePercentage: UInt) {
        self.features = features
        self.devicePercentage = devicePercentage
        self.currentPlatform = Platform.currentDevice()
    }

    public func isActive(featureName: FeatureName) -> Bool {
        return isActive(featureName.rawValue)
    }

    internal func isActive(name: String) -> Bool {
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

    internal mutating func updatePercentage(percentage: UInt) {
        devicePercentage = percentage
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

public func isActive(feature: FeatureName) -> Bool {
    return FeatureService.featureStore.isActive(feature)
}

extension FeatureStore: CustomDebugStringConvertible {
    public var debugDescription: String {
        return features.debugDescription
    }
}
