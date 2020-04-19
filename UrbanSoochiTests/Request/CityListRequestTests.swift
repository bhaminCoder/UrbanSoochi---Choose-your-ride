//
//  CityListRequestTests.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 17/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import UrbanSoochi

class CityListRequestTests: XCTestCase {

    var cityListRequest: CityListRequest?
    var mockRequest: MockCityListRequest?

    override func setUp() {
        super.setUp()
        self.cityListRequest = CityListRequest()
        self.mockRequest = MockCityListRequest()
    }

    override func tearDown() {
        self.cityListRequest = nil
        self.mockRequest = nil
        super.tearDown()
    }

    func testForBaseUrl() {
        XCTAssertEqual(self.mockRequest?.baseUrl(), self.cityListRequest?.baseUrl())
    }

    func testForPath() {
        XCTAssertEqual(self.mockRequest?.path(), self.cityListRequest?.path())
    }

    func testForMethod() {
        XCTAssertEqual(self.mockRequest?.method(), self.cityListRequest?.method())
    }

    func testForData() {
        XCTAssertNil(self.cityListRequest?.data())
    }

    func testForError() {
        XCTAssertNil(self.cityListRequest?.error())
    }
}
