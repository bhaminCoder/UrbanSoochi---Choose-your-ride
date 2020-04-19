//
//  CityListRequest.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class CityListRequest: APIRequest {

    typealias ModelType = Cities

    func baseUrl() -> String {
        return "https://jsonblob.com/api/173183a3-47f2-11ea-a44d-635fc7abe276"
    }

    func path() -> String {
        return ""
    }

    func method() -> String {
        return "GET"
    }

    func data() -> Data? {
        return nil
    }

    func error() -> NetworkError? {
        return nil
    }
}
