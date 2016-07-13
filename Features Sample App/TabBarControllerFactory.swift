//
//  TabBarControllerFactory.swift
//  Features
//
//  Created by iainsmith on 12/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import UIKit
import Features

class TabBarControllerFactory {
    static func controllerWithFeatures(featureStore: FeatureStore = FeatureService.featureStore) -> UITabBarController {
        let tabBar = UITabBarController()

        var viewControllers: [UIViewController] = []

        if featureStore.isActive(.redController) {
            viewControllers.append(controllerWithColor(.redColor(), title: "red"))
        }

        if featureStore.isActive(.yellowController) {
            viewControllers.append(controllerWithColor(.yellowColor(), title: "Yellow"))
        }

        if featureStore.isActive(.greenController) {
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
