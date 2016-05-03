//
//  FeaturesObjectiveCTests.m
//  Features
//
//  Created by iainsmith on 04/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

#import <XCTest/XCTest.h>
@import Features;

@interface FeatureName (Objc)

+ (FeatureName *)firstFeature NS_SWIFT_UNAVAILABLE("Use swift static property");

@end

@implementation FeatureName (Objc)

+ (FeatureName *)firstFeature
{
    return [[FeatureName alloc] initWithRawValue:@"First Feature"];
}

@end

@interface FeaturesObjectiveCTests : XCTestCase

@end

@implementation FeaturesObjectiveCTests

- (void)testFeatureStore
{
    [FeatureServiceShim setBundle:[NSBundle bundleForClass:self.class]];

    XCTAssertTrue([FeatureServiceShim featureEnabled:FeatureName.firstFeature]);
    XCTAssertTrue(FEATURE_ENABLED(FeatureName.firstFeature));
}

@end
