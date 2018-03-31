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

class BundleMarker {}

private let testBundle = Bundle(for: BundleMarker.self)

class FeaturesServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        FeatureService.bundle = testBundle
        FeatureService.overRidePercentage = 30
    }

    func testLoadingFeaturesFromDifferentBundle() {
        let store = FeatureService.featureStore
        XCTAssert(store.features.count == 4)
        XCTAssertTrue(store.currentPlatform.contains(.iPhone))
    }

    func testDecodingFeatureDefinitions() throws {
        let json = testBundle.url(forResource: "features", withExtension: "json")!
        let data = try Data(contentsOf: json)
        let features = try JSONDecoder().decode([Feature].self, from: data)
        XCTAssertNotNil(features)
    }

    func testFeatures() {
        FeatureService.bundle = testBundle
        let store = FeatureService.featureStore
        XCTAssert(store.features.count == 4)
        XCTAssertTrue(store.isActive(.One))
        XCTAssertTrue(isActive(feature: .One))
        XCTAssertFalse(isActive(feature: .Second))

        let secondFeature = store.features.filter { $0.name == FeatureName.Second.rawValue }.first!
        XCTAssertFalse(secondFeature.active)
        XCTAssertTrue(secondFeature.rolloutPercentage == 100)
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

        let first = Feature(name: firstFeature.rawValue, rolloutPercentage: 30, platforms: .all, section: .none, active: true)
        let second = Feature(name: secondFeature.rawValue, rolloutPercentage: 80, platforms: .all, section: .none, active: true)

        var stores: [FeatureStore] = []
        for _ in 1...10000 {
            let percentage = RandomPercentageGenerator.generate()
            let store = FeatureStore(features: [first, second], devicePercentage: percentage, platform: .iPhone)
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
