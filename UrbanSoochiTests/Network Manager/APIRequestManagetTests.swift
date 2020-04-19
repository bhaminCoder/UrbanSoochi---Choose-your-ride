//
//  APIRequestManagetTests.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 17/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import UrbanSoochi

class APIRequestManagetTests: XCTestCase {

    var mockRequest: MockCityListRequest?
    var urlRequest: URLRequest?

    override func setUp() {
        super.setUp()
        self.mockRequest = MockCityListRequest()
        self.urlRequest = URLRequest(request: self.mockRequest!)
    }

    override func tearDown() {
        self.mockRequest = nil
        self.urlRequest = nil

        super.tearDown()
    }

    func testForExecuteAPIRequest() {
        APIRequestManager.executeAPIRequest(self.mockRequest!) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
    }

    func testForExecuteAPIRequestForError() {
        let mockInvalidRequest = MockInvalidRequest()
        APIRequestManager.executeAPIRequest(mockInvalidRequest) { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
        }
    }

    func toDecodedModelData() {
        let cities = APIRequestManager.toDecodedModelData((self.mockRequest?.data())!, modelType: CitiesAPIData.self)
        XCTAssertNotNil(cities)
        XCTAssertNotNil(cities?.cities)
        XCTAssertNotNil(cities?.countriesList)

        let city = cities?.cities?.first
        XCTAssertEqual(city!.name, "Sydney")

        let country = cities?.countriesList?.first
        XCTAssertEqual(country!, "United States")
    }

    func testForURLRequestInit() {
        let request = URLRequest.init(request: self.mockRequest!)
        XCTAssertNotNil(request!)
    }

    func testForURLRequestUrlPath() {
        let expectedUrlPath = self.mockRequest!.baseUrl() + self.mockRequest!.path()
        let urlPathOfUrlRequest = self.urlRequest?.url?.absoluteString
        XCTAssertEqual(expectedUrlPath, urlPathOfUrlRequest)
    }

    func testForURLRequestMethod() {
        XCTAssertEqual(self.urlRequest!.httpMethod!, "GET")
    }

    func testForURLRequestTimeOut() {
        XCTAssertEqual(self.urlRequest!.timeoutInterval, 20.0)
    }
}
