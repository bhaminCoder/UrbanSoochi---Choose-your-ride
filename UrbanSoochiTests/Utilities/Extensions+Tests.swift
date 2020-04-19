//
//  Extensions+Tests.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 19/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import UrbanSoochi

class Extensions_Tests: XCTestCase {

    func testForIsASubSetForGivenText() {
        let inputText = "Hello World!"
        let searchKey = "orl"
        let isSubset = searchKey.isASubSetOf(givenText: inputText)
        XCTAssertTrue(isSubset)
    }

    func testForIsASubsetForInvalidKey() {
        let inputText = "Hello World!"
        let searchKey = "123"
        let isSubset = searchKey.isASubSetOf(givenText: inputText)
        XCTAssertFalse(isSubset)
    }

    func testForSortedDictionaryKeyPaths() {
        let city: [String: String] = ["Maharashtra": "Mumbai", "Karnataka": "Bengaluru"]
        let sortedCityKeyPaths = city.sortedKeyPaths
        XCTAssertTrue(sortedCityKeyPaths.count == 2)
        XCTAssertEqual(sortedCityKeyPaths[0], "Karnataka")
        XCTAssertEqual(sortedCityKeyPaths[1], "Maharashtra")
    }

    func testForGroupSequence() {
        let newYorkCity = City(name: "New York", country: "USA", latitude: 68.11, longitude: 223.22, temperature: 25.0)
        let bengaluruCity = City(name: "Bengaluru", country: "INDIA", latitude: 53.22, longitude: 87.22, temperature: 22.0)
        let cities = [newYorkCity, bengaluruCity]
        let groupedCitiesByCountry = cities.group(by: {$0.country})
        XCTAssertNotNil(groupedCitiesByCountry)
        XCTAssertEqual(groupedCitiesByCountry["USA"]?.first!.country, newYorkCity.country)
        XCTAssertEqual(groupedCitiesByCountry["INDIA"]?.first!.country, bengaluruCity.country)
    }
}
