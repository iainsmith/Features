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

struct Platform: OptionSetType {
    let rawValue: Int
    static let iPhone = Platform(rawValue: 1)
    static let iPad   = Platform(rawValue: 2)
    static let tvOS   = Platform(rawValue: 3)
    static let All: Platform = [.iPhone, .iPad, .tvOS]


    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init?(string: String?) {
        guard let string = string else { return nil }

        switch string.lowercaseString {
        case "iphone":
            self = Platform.iPhone
        case "ipad":
            self = Platform.iPad
        case "tvos":
            self = Platform.tvOS
        case "all":
            self = Platform.All
        default:
            return nil
        }
    }

    static func platFormFromJSONString(jsonString: String?) -> Platform? {
        guard let jsonString = jsonString else { return Platform.All }

        var platform: Platform = []
        let string = jsonString.lowercaseString
        ["iphone", "ipad", "tvos"].forEach { member in
            if string.containsString(member) {
                if let _ = Platform(string: member) {
                    platform.insert(Platform())
                }
            }
        }

        if platform.isEmpty {
            return nil
        }

        return platform
    }

    static func currentDevice() -> Platform {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .TV:
            return .tvOS
        case .Phone:
            return .iPhone
        case .Pad:
            return .iPad
        default:
            return .iPhone
        }
    }
}

extension Platform: CustomDebugStringConvertible {
    var debugDescription: String {
        var platforms = [String]()
        if self.contains(.iPhone) {
            platforms.append("iPhone")
        }

        if self.contains(.iPad) {
            platforms.append("iPad")
        }

        if self.contains(.tvOS) {
            platforms.append("TVOS")
        }

        return platforms.joinWithSeparator(", ")
    }
}

struct Feature {
    let name: String
    let active: Bool
    let rolloutPercentage: UInt
    let platforms: Platform
}

public struct FeatureStore {
    let features: [Feature]
    let devicePercentage: UInt // Needs to be persisted across runs
    let currentPlatform: Platform

    init(features: [Feature], devicePercentage: UInt) {
        self.features = features
        self.devicePercentage = devicePercentage
        self.currentPlatform = Platform.currentDevice()
    }

    public func featureEnabled(featureName: FeatureName) -> Bool {
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
}

public func featureEnabeld(feature: FeatureName) -> Bool {
    return FeatureService.featureStore.featureEnabled(feature)
}

extension FeatureStore: CustomDebugStringConvertible {
    public var debugDescription: String {
        return features.debugDescription
    }
}
