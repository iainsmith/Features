//
//  Features.swift
//  Features
//
//  Created by iainsmith on 03/05/2016.
//  Copyright © 2016 Mountain23. All rights reserved.
//

import Foundation

public struct FeatureName: Equatable {
    let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static func == (lhs: FeatureName, rhs: FeatureName) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public struct Feature {
    public let name: String
    internal let rolloutPercentage: UInt
    internal let platforms: Platform
    internal let section: String?
    internal let active: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case rolloutPercentage = "percentage"
        case platforms
        case section
        case active
    }
}

extension Feature: Decodable {
    public init(from decoder: Decoder) throws {
        let keyed = try decoder.container(keyedBy: CodingKeys.self)
        name = try keyed.decode(String.self, forKey: .name)
        rolloutPercentage = try keyed.decodeIfPresent(UInt.self, forKey: .rolloutPercentage) ?? 100
        platforms = try keyed.decodeIfPresent(Platform.self, forKey: .platforms) ?? Platform.all
        section = try keyed.decodeIfPresent(String.self, forKey: .section)
        active = try keyed.decode(Bool.self, forKey: .active)
    }
}

extension Feature: Equatable {
    public static func == (lhs: Feature, rhs: Feature) -> Bool {
        return lhs.name == rhs.name && lhs.active == rhs.active && rhs.rolloutPercentage == rhs.rolloutPercentage && lhs.platforms.rawValue == rhs.platforms.rawValue
    }
}
