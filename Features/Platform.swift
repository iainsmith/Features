//
//  Platform.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import Foundation

struct Platform: OptionSetType {
    let rawValue: Int
    static let iPhone = Platform(rawValue: 1)
    static let iPad   = Platform(rawValue: 2)
    static let tvOS   = Platform(rawValue: 3)
    static let All: Platform = [.iPhone, .iPad, .tvOS]


    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init?(string: String?) {
        guard let string = string else { return nil }

        switch string.lowercaseString {
        case "iphone":
            self = Platform.iPhone
        case "ipad":
            self = Platform.iPad
        case "tvos":
            self = Platform.tvOS
        case "all":
            self = Platform.All
        default:
            return nil
        }
    }

    static func platFormFromJSONString(jsonString: String?) -> Platform? {
        guard let jsonString = jsonString else { return Platform.All }

        var platform: Platform = []
        let string = jsonString.lowercaseString
        ["iphone", "ipad", "tvos"].forEach { member in
            if string.containsString(member) {
                if let _ = Platform(string: member) {
                    platform.insert(Platform())
                }
            }
        }

        if platform.isEmpty {
            return nil
        }

        return platform
    }

    static func currentDevice() -> Platform {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .TV:
            return .tvOS
        case .Phone:
            return .iPhone
        case .Pad:
            return .iPad
        default:
            return .iPhone
        }
    }
}

extension Platform: CustomDebugStringConvertible {
    var debugDescription: String {
        var platforms = [String]()
        if self.contains(.iPhone) {
            platforms.append("iPhone")
        }

        if self.contains(.iPad) {
            platforms.append("iPad")
        }

        if self.contains(.tvOS) {
            platforms.append("TVOS")
        }

        return platforms.joinWithSeparator(", ")
    }
}
