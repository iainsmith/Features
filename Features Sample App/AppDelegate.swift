//
//  AppDelegate.swift
//  Features Sample App
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import UIKit
import Features

extension FeatureName {
    @nonobjc static let yellowController = FeatureName(rawValue: "Yellow controller")
    @nonobjc static let redController = FeatureName(rawValue: "Red controller")
    @nonobjc static let greenController = FeatureName(rawValue: "Green controller")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let featuresController = FeaturesViewController(delegate: self)

        window?.rootViewController = UINavigationController(rootViewController: featuresController)
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: FeaturesViewControllerDelegate {
    func featuresViewControllerFinished(controller: FeaturesViewController) {
        window?.rootViewController = TabBarControllerFactory.controllerWithFeatures()
    }
}

class TabBarControllerFactory {
    static func controllerWithFeatures(features: FeatureStore = FeatureService.featureStore) -> UITabBarController{
        let tabBar = UITabBarController()

        var viewControllers: [UIViewController] = []

        if features.isActive(.redController) {
            viewControllers.append(controllerWithColor(.redColor(), title: "red"))
        }

        if features.isActive(.yellowController) {
            viewControllers.append(controllerWithColor(.yellowColor(), title: "Yellow"))
        }

        if features.isActive(.greenController) {
            viewControllers.append(controllerWithColor(.greenColor(), title: "green"))
        }

        tabBar.viewControllers = viewControllers

        return tabBar
    }

    private static func controllerWithColor(color: UIColor, title: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = color
        vc.title = title
        return vc
    }
}