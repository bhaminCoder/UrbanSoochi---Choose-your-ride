//
//  MockCityListRequest.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 17/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation
@testable import UrbanSoochi

class MockCityListRequest: CityListRequest {

    typealias ModelType = CitiesAPIData

    override func baseUrl() -> String {
        return "https://jsonblob.com/api/173183a3-47f2-11ea-a44d-635fc7abe276"
    }

    override func path() -> String {
        return ""
    }

    override func method() -> String {
        return "GET"
    }

    override func data() -> Data? {
        return self.mockData()
    }

    override func error() -> NetworkError? {
        return nil
    }

    private func mockData() -> Data? {
        if let path = Bundle.main.path(forResource: "ListOfCities", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            return data
        }
        return nil
    }
}
