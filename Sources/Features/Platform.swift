//
//  Platform.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

struct Platform: OptionSet, Codable {
    let rawValue: Int

    static let iPhone = Platform(rawValue: 1 << 0)
    static let iPad   = Platform(rawValue: 1 << 1)
    static let tvOS   = Platform(rawValue: 1 << 2)
    static let web    = Platform(rawValue: 1 << 3)
    static let mac    = Platform(rawValue: 1 << 4)
    static let all: Platform = [.iPhone, .iPad, .tvOS, .web, .mac]


    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init?(string: String?) {
        guard let string = string else { return nil }

        switch string.lowercased() {
        case "iphone":
            self = Platform.iPhone
        case "ipad":
            self = Platform.iPad
        case "tvos":
            self = Platform.tvOS
        case "mac":
            self = Platform.mac
        case "all":
            self = Platform.all
        default:
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        print(decoder.codingPath)
        let c = try decoder.singleValueContainer()
        let strings = try c.decode([String].self)
        var combined = Platform()
        strings.flatMap({ Platform(string:$0) }).forEach { combined.insert($0) }
        self.rawValue = combined.rawValue
    }
}

extension Platform {
    static func currentDevice() -> Platform {
        #if os(Linux)
            return Platform.web
        #elseif os(macOS)
            return Platform.mac
        #else
            return UIDevice.currentPlatform()
        #endif
    }
}

extension Platform: CustomDebugStringConvertible {
    var displayString: String {
        get {
            var platforms = [String]()
            if self.contains(.iPhone) { platforms.append("iPhone") }
            if self.contains(.iPad) { platforms.append("iPad") }
            if self.contains(.tvOS) { platforms.append("TVOS") }
            if self.contains(.web) { platforms.append("web") }
            if self.contains(.mac) { platforms.append("TVOS") }


            if platforms.count == 4 { platforms = ["All"] }
            
            return platforms.joined(separator: ", ")
        }
    }

    var debugDescription: String {
        return displayString
    }
}
