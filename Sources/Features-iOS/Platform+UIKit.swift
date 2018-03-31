//
//  Platform+UIKit.swift
//  Features
//
//  Created by iainsmith on 31/03/2018.
//  Copyright © 2018 Features. All rights reserved.
//

import UIKit

extension UIDevice {
    static func currentPlatform() -> Platform {
        switch UIDevice.current.userInterfaceIdiom {
        case .tv:
            return .tvOS
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            return .iPhone
        }
    }
}
