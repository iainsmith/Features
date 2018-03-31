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
    public static var bundle = Bundle.main
    public static var overRidePercentage: UInt? = nil
    public static var store: FeaturePercentageStore = UserDefaults.standard
    public static var featureStore: FeatureStore = FeatureService.latestSavedStore()
    private static var remoteClient = FeatureClient()


    public static func featureDetails() -> [FeatureData] {
        return featureStore.features.map { feature in
            let name = feature.name
            let active = featureStore.isActive(FeatureName(rawValue: name))
            return (name: name, active: active)
        }
    }

    public static func updatePercentage(_ percentage: UInt) {
        store.feature_storedPercentage = percentage
        featureStore = FeatureStore(features: featureStore.features, devicePercentage: percentage, platform: Platform.currentDevice())
    }

    public static func devicePercentage() -> UInt {
       return overRidePercentage ?? existingPercentage() ?? generatedSavedPercentage()
    }

    public static func updateRemoteFeaturesWithRequest(_ request: URLRequest) {
        remoteClient.updateFeatures(request: request) { result in
            switch result {
            case .success(let store, let data):
                saveAndUpdateFeatureStore(store: store, data: data)
            case .failure:
                print("failed to update features from request")
            }
        }
    }
}


extension FeatureService {
    private static func latestSavedStore() -> FeatureStore {
        return latestRemoteStore() ?? latestLocalStore()
    }

    private static func latestRemoteStore() -> FeatureStore? {
        // Use strict mode so consumers are less likely to break things.
        let url = URL(fileURLWithPath: remoteFilePath())
        return FeatureParser.loadFromPath(url, strict: true)
    }

    private static func remoteFolderPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    }

    private static func remoteFilePath() -> String {
        var supportPath = remoteFolderPath()
        supportPath.append("/features.json")
        return supportPath
    }

    private static func latestLocalStore() -> FeatureStore {
        return FeatureParser.loadFromDisk()
    }

    private static func updateLatestJSONWithData(data: Data) throws {
        let fileManager = FileManager.default
        let folderPath = remoteFolderPath()

        if fileManager.fileExists(atPath: folderPath) == false {
            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        }

        let filePath = remoteFilePath()
        let url = URL(fileURLWithPath: filePath)
        try data.write(to: url, options: [.atomicWrite])
        print("data saved to \(filePath)")
    }

    private static func saveAndUpdateFeatureStore(store: FeatureStore, data: Data) {
        do {
            try updateLatestJSONWithData(data: data)
        } catch {
            print("failed to write features to disk")
        }
    }
}

// MARK: - Device Percentages
extension FeatureService {
    private static func existingPercentage() -> UInt? {
        return store.feature_storedPercentage
    }

    private static func generatedSavedPercentage() -> UInt {
        let percentage = RandomPercentageGenerator.generate()
        store.feature_storedPercentage = percentage
        return percentage
    }
}
