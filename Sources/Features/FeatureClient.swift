//
//  FeatureClient.swift
//  Features
//
//  Created by iainsmith on 23/09/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import Foundation

enum FeatureResult<T> {
    case success(T)
    case failure()
}

class FeatureClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func updateFeatures(request: URLRequest, completion: (@escaping (FeatureResult<(FeatureStore, Data)>) -> Void)) {
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                let result = FeatureParser.loadFromData(data, strict: true)
                completion(result)
            } else {
                completion(.failure())
            }
        }.resume()
    }
}
