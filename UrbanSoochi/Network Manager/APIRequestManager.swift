//
//  APIRequestManager.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class APIRequestManager {

    static func executeAPIRequest<T: APIRequest>(_ request: T, completion: @escaping(Data?, NetworkError?) -> Void) {

        guard let urlRequest = URLRequest(request: request) else {
            completion(nil, .invalidURL)
            return
        }

        //The below condition is solely for the purpose of testing while passing-in the mocked data and error objects
        if request.data() != nil || request.error() != nil {
            completion(request.data(), request.error())
            return
        }

        let task = request.urlSession().dataTask(with: urlRequest) { (data, _, error) in
            if let data = data {
                completion(data, nil)
            }
            if error != nil {
                completion(nil, .noData) // As of now assuming it to be an absence of data
            }
        }
        task.resume()
    }

    //Decode and returns the data of a specific Codable modelType if valid,
    //Else returns nil
    static func toDecodedModelData<T>(_ data: Data, modelType: T.Type) -> T? where T: Decodable {
        let decoder = JSONDecoder()
        guard let modeldata = try? decoder.decode(modelType, from: data) else {
            NSLog("Invalid Model")
            return nil
        }
        return modeldata
    }
}

extension URLRequest {

    init?<T: APIRequest>(request: T) {
        let urlString = (request.baseUrl()+request.path())
        guard  let relativeURL = URL(string: urlString) else {
            return nil
        }

        self.init(url: relativeURL)
        self.timeoutInterval = 20.0 //Assumption
        self.httpMethod = request.method()
    }
}
