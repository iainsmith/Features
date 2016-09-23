//
//  FeatureClient.swift
//  Features
//
//  Created by iainsmith on 23/09/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import Foundation

enum FeatureResult<T> {
    case Success(T)
    case Failure()
}

class FeatureClient {
    var session = NSURLSession.sharedSession()

    func updateFeatures(request: NSURLRequest, completion: (FeatureResult<(FeatureStore, NSData)> -> Void)) {
        session.dataTaskWithRequest(request) { data, response, error in
            if let data = data {
                let result = FeatureParser.loadFromData(data, strict: true)
                completion(result)
            } else {
                completion(.Failure())
            }
        }.resume()
    }
}
