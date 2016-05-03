//
//  FeatureMacro.h
//  Features
//
//  Created by iainsmith on 08/07/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FEATURE_ENABLED(featureName) [FeatureServiceShim featureEnabled:featureName]