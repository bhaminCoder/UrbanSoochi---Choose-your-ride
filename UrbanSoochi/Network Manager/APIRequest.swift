//
//  APIRequest.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

protocol APIRequest: class {
    associatedtype ModelType: Codable

    func baseUrl() -> String
    func path() -> String
    func method() -> String

    func urlSession() -> URLSession

    //Below methods would be used solely for the purpose of testing/mocking
    func data() -> Data?
    func error() -> NetworkError?
}

extension APIRequest {
    public func urlSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: .main)
    }
}
