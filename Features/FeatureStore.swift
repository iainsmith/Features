//
//  FeatureStore.swift
//  Features
//
//  Created by iainsmith on 12/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import Foundation

public struct FeatureStore {
    let features: [Feature]
    let devicePercentage: UInt
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

            let activeForUser: Bool
            if let rolloutPercentage = feature.rolloutPercentage {
                activeForUser = (devicePercentage <= rolloutPercentage)
            } else {
                activeForUser = true
            }

            let activePlatform = feature.platforms.contains(currentPlatform)

            return feature.active && activeForUser && activePlatform
        }

        return false
    }

    func featureStoreByUpdatingFeature(feature: Feature) -> FeatureStore {
        var localFeaturs = features
        let index = localFeaturs.indexOf { $0.name == feature.name }

        if let index = index {
            localFeaturs[index] = feature
        } else {
            localFeaturs.append(feature)
        }

        return FeatureStore(features: localFeaturs, devicePercentage: devicePercentage)
    }
}

public func isActive(feature: FeatureName) -> Bool {
    return FeatureService.featureStore.isActive(feature)
}

extension FeatureStore: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(features) \(devicePercentage)% \(currentPlatform)"
    }
}
