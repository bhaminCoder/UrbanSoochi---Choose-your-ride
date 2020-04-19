//
//  APIRequestTests.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 17/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import UrbanSoochi

class APIRequestTests: XCTestCase {

    func testForBaseUrl() {
        XCTAssertEqual("baseUrl", self.baseUrl())
    }

    func testForPath() {
        XCTAssertEqual("path", self.path())
    }

    func testForMethod() {
        XCTAssertEqual("GET", self.method())
    }

    func testForData() {
        XCTAssertNil(self.data())
    }

    func testForError() {
        XCTAssertNil(self.error())
    }
}

extension APIRequestTests: APIRequest {

    typealias ModelType = Cities

    func baseUrl() -> String {
        return "baseUrl"
    }

    func path() -> String {
        return "path"
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
