# Features

## Disclaimer

Using feature toggles increases the complexity of:

* Your code
* Your manual and automatic testing
* Your release process

Before using this library you should understand the benefits, tradeoffs, security implications and risks of using feature toggle based development. If you are planning to submit your app to the Apple App Store you are responsible for complying with all the submission rules.

# Summary

`Features` is a small library that enables feature toggle based development in Swift & Objective-C. If you would like a more in depth analysis of feature toggles, I'd recommend checking out [this article](http://martinfowler.com/articles/feature-toggles.html) from Pete Hodgson.

`Features` supports

* Platform specific features. e.g Enable this features on iPhone but not iPad
* Percentage based rollout of features. e.g Enable this feature for 10% of devices
* Updating feature toggles remotely. e.g Update this feature from 10% to 100% without a resubmission.

# Adding a feature toggle to your app

To generate an example feature flag you can install the features ruby gem

1. `gem install swift_features`
2. `features bootstrap`

(Alternatively copy the features_example.json to your project directory)

`features bootstrap` create 4 files.

* features.json - Your custom feature definitions
* Features.swift, Features.h, Features.m - `FeatureName` class generated from features.json

3. Add all 4 files to your main app target.

4. Open your AppDelegate.swift and add this line

```swift
if isActive(.example) { print("The example feature is active") }
```

Alternatively in Objective-C

```objc
if (FEATURE_ACTIVE(FeatureName.example)) { NSLog("The example feature is active") }
```
5. Open features.json in a text editor and rename the example feature to something relevant to your project

6. Run `features generate` and you'll see features.h/m and features.swift update to reflect your new features.

7. Your code should no longer compile so update your AppDelegate call to use the new `FeatureName` found in Features.h/swift

# JSON format

Your features are defined in features.json in the format below.

```json
[
    {
        "name": "First Feature",
        "active": true,
        "percentage": 30,
        "platforms" : "iPhone"
    },
    {
        "Name": "Second Feature",
        "active": false
    },
    {
        "name": "Third Feature",
        "active": true,
        "platforms": "iphone,ipad"
    }
]
```

# App Security
The features.json file is shipped in your application in a human readable form. It's very easy for a jailbroken user to manually edit this file, or for a user to intercept and edit the json file if you are using remote feature updates.

YOU SHOULD NEVER CREATE A FEATURE THAT WOULD CREATE A SECURITY VUNELABILITY OR THAT SHOULD NOT BE PUBLICALLY VISIBLE.

e.g "disable receipt verification"



