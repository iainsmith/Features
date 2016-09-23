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
    public static var store: FeaturePercentageStore = NSUserDefaults.standardUserDefaults()
    public static var featureStore: FeatureStore = FeatureService.latestSavedStore()
    private static var remoteClient = FeatureClient()


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

    public static func devicePercentage() -> UInt {
       return overRidePercentage ?? existingPercentage() ?? generatedSavedPercentage()
    }

    public static func updateRemoteFeaturesWithRequest(request: NSURLRequest) {
        remoteClient.updateFeatures(request) { result in
            switch result {
            case .Success(let store, let data):
                saveAndUpdateFeatureStore(store, data: data)
            case .Failure:
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
        return FeatureParser.loadFromPath(remoteFilePath(), strict: true)
    }

    private static func remoteFolderPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
    }

    private static func remoteFilePath() -> String {
        var supportPath = remoteFolderPath()
        supportPath.appendContentsOf("/features.json")
        return supportPath
    }

    private static func latestLocalStore() -> FeatureStore {
        return FeatureParser.loadFromDisk()
    }

    private static func updateLatestJSONWithData(data: NSData) throws {
        let fileManager = NSFileManager.defaultManager()
        let folderPath = remoteFolderPath()

        if fileManager.fileExistsAtPath(folderPath) == false {
            try fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        }

        let filePath = remoteFilePath()
        try data.writeToFile(filePath, options: [.DataWritingAtomic])
        print("data saved to \(filePath)")
    }

    private static func saveAndUpdateFeatureStore(store: FeatureStore, data: NSData) {
        do {
            try updateLatestJSONWithData(data)
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

internal struct RandomPercentageGenerator {
    static func generate() -> UInt {
        return UInt(arc4random_uniform(100) + 1)
    }
}
