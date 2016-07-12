//
//  ObjCShim.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

public class FeatureServiceShim: NSObject {
    public static func setBundle(bundle: NSBundle) {
        FeatureService.bundle = bundle
    }

    public static func setFileName(fileName: String) {
        FeatureService.fileName = fileName
    }

    public static func isActive(feature: FeatureName) -> Bool {
        return FeatureService.featureStore.isActive(feature)
    }

    public static func isActiveFeatureName(featureName: String) -> Bool {
        let feature = FeatureName(rawValue: featureName)
        return FeatureService.featureStore.isActive(feature)
    }
}
