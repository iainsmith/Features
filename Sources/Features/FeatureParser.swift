//
//  FeatureParser.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

internal struct FeatureParser {
    static func loadFromDisk(percentage: UInt = FeatureService.devicePercentage(), bundle: Bundle = FeatureService.bundle, fileName: String = FeatureService.fileName) -> FeatureStore {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else { fatalError() }
        return loadFromPath(path, percentage: percentage)!
    }

    static func loadFromPath(_ path: URL, percentage: UInt = FeatureService.devicePercentage(), strict: Bool = false) -> FeatureStore? {
        guard let data = try? Data(contentsOf: path) else { return nil }
        let result = loadFromData(data, percentage: percentage, strict: strict)
        switch result {
        case .success(let store):
            return store.0
        case .failure:
            return nil
        }
    }

    static func loadFromData(_ data: Data, percentage: UInt = FeatureService.devicePercentage(), strict: Bool) -> FeatureResult<(FeatureStore, Data)> {
        do {
            let features = try JSONDecoder().decode([Feature].self, from: data)
            if strict == false || features.count == features.count {
                let store = FeatureStore(features: features, devicePercentage: percentage, platform: Platform.currentDevice())
                return .success((store, data))
            } else {
                return .failure()   
            }
        } catch {
            return .failure()
        }
    }
}
