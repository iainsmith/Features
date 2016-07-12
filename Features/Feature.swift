//
//  Features.swift
//  Features
//
//  Created by iainsmith on 03/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringLiteralConvertible {
    mutating func lowercaseKeys() {
        for key in self.keys {
            self[String(key).lowercaseString as! Key] = self.removeValueForKey(key)
        }
    }
}

public class FeatureName: NSObject, RawRepresentable {
    public let rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public func ==(lhs: FeatureName, rhs: FeatureName) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public enum Section {
    case None
    case Some(name: String)

    var name: String {
        get {
            switch self {
            case .None:
                return "no section"
            case .Some(let name):
                return name
            }
        }
    }
}

public struct Feature {
    public let name: String
    public let rolloutPercentage: UInt?
    internal let platforms: Platform
    public let section: Section
    public let active: Bool
}

public func == (lhs: Feature, rhs: Feature) -> Bool {
    return lhs.name == rhs.name && lhs.active == rhs.active && rhs.rolloutPercentage == rhs.rolloutPercentage && lhs.platforms == rhs.platforms
}

extension Feature: Equatable { }
