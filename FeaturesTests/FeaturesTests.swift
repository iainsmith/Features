//
//  FeaturesTests.swift
//  FeaturesTests
//
//  Created by iainsmith on 03/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import XCTest
@testable import Features

extension FeatureName {
    @nonobjc static let One = FeatureName(rawValue: "First Feature")
    @nonobjc static let Second = FeatureName(rawValue: "Second Feature")
    @nonobjc static let Third = FeatureName(rawValue: "Third Feature")
}

class FeaturesServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        FeatureService.bundle = NSBundle(forClass:self.dynamicType)
        FeatureService.overRidePercentage = 30
    }

    func testLoadingFeaturesFromDifferentBundle() {
        let store = FeatureService.featureStore
        XCTAssert(store.features.count == 3)
        XCTAssertTrue(store.currentPlatform.contains(.iPhone))
    }

    func testFeatures() {
        FeatureService.bundle = NSBundle(forClass:self.dynamicType)
        let store = FeatureService.featureStore
        XCTAssert(store.features.count == 3)
        XCTAssertTrue(store.isActive(.One))
        XCTAssertTrue(isActive(.One))
        XCTAssertFalse(isActive(.Second))

        let secondFeature = store.features.filter { $0.name == FeatureName.Second.rawValue }.first!
        XCTAssertFalse(secondFeature.active)
        XCTAssertTrue(secondFeature.rolloutPercentage == 0)
    }

    func testMultiplePlatforms() {
        let store = FeatureService.featureStore

        let third = store.features.filter { $0.name == FeatureName.Third.rawValue }.first!
        let platforms = third.platforms
        XCTAssertTrue(platforms.contains(.iPhone) && platforms.contains(.iPad))
    }

    func testDistribution() {
        let firstFeature = FeatureName(rawValue: "Feature one")
        let secondFeature = FeatureName(rawValue: "Feature two")

        let first = Feature(name: firstFeature.rawValue, rolloutPercentage: 30, platforms: .All, section: .None, active: true)
        let second = Feature(name: secondFeature.rawValue, rolloutPercentage: 80, platforms: .All, section: .None, active: true)

        var stores: [FeatureStore] = []
        for _ in 1...10000 {
            let percentage = RandomPercentageGenerator.generate()
            let store = FeatureStore(features: [first, second], devicePercentage: percentage)
            stores.append(store)
        }

        let firstResult = stores.map { $0.isActive(firstFeature) }
        let secondResult = stores.map { $0.isActive(secondFeature) }

        let firstActive = firstResult.filter { $0 == true }.count
        let secondActiveCount = secondResult.filter { $0 == true }.count
        XCTAssert(firstActive >= 2900 && firstActive <= 3100)
        XCTAssert(secondActiveCount >= 7900 && secondActiveCount <= 8100)
    }
}
