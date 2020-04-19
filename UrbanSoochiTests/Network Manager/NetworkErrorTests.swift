//
//  NetworkErrorTests.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 18/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import UrbanSoochi

class NetworkErrorTests: XCTestCase {

    func testForNoDataLocalisedDescription() {
        let noDataError = NetworkError.noData
        let noDataErrorMessage = ErrorMessage.noDataError
        XCTAssertEqual(noDataError.localizedDescription, noDataErrorMessage)
    }

    func testForInvalidURLLocalisedDescription() {
        let invalidURLError = NetworkError.invalidURL
        let invalidURLErrorMessage = ErrorMessage.invalidUrlError
        XCTAssertEqual(invalidURLError.localizedDescription, invalidURLErrorMessage)
    }
}
