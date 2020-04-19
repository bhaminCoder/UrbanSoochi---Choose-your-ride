//
//  CitiesListViewModelTests.swift
//  UrbanSoochiTests
//
//  Created by Vinayak.gh on 17/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import UrbanSoochi

class CitiesListViewModelTests: XCTestCase {

    var mockRequest: MockCityListRequest?
    var mockInvalidRequest: MockInvalidRequest?
    var viewModel: CitiesListViewModel?

    override func setUp() {
        super.setUp()
        self.mockRequest = MockCityListRequest()
        self.mockInvalidRequest = MockInvalidRequest()
        self.viewModel = CitiesListViewModel()

        let cities = self.viewModel?.decodeCitiesData(data: (self.mockRequest?.data())!)
        self.viewModel?.countriesAndCities = self.viewModel?.groupCitiesData(cities!)
    }

    override func tearDown() {
        self.mockRequest = nil
        self.mockInvalidRequest = nil
        self.viewModel = nil
        self.viewModel?.countriesAndCities = nil
        super.tearDown()
    }

    func testForGetListOfCitiesForSuccessfulCompletion() {
        self.viewModel?.getListOfCities(request: self.mockRequest!, completion: { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNotNil(self.viewModel?.countriesAndCities?.citiesGroupedByCountry)
            XCTAssertNil(error)
        })
    }

    func testForGetListOfCitiesForError() {
        self.viewModel?.getListOfCities(request: self.mockInvalidRequest!, completion: { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, NetworkError.noData.localizedDescription)
        })
    }

    func testForDecodeValidCitiesData() {
        let cities = self.viewModel?.decodeCitiesData(data: self.mockRequest!.data()!)
        XCTAssertNotNil(cities)
        XCTAssertTrue(cities!.count > 0)
        XCTAssertEqual(cities?.first?.name, "Sydney")
        XCTAssertEqual(cities?.last?.country, "Netherlands")
    }

    func testForDecodeInvalidCitiesData() {
        let cities = self.viewModel?.decodeCitiesData(data: Data())
        XCTAssertNil(cities)
    }

    func testGroupedCitiesData() {
        let cities = self.viewModel?.decodeCitiesData(data: self.mockRequest!.data()!)
        let countriesAndCities = self.viewModel?.groupCitiesData(cities!)

        let mockGroupedCitiesAndCountries = countriesAndCities?.cities.sortedByName.groupedByCountry
        let citiesWithCountry = countriesAndCities?.citiesGroupedByCountry

        XCTAssertNotNil(mockGroupedCitiesAndCountries)
        XCTAssertNotNil(citiesWithCountry)

        let mockedCities = mockGroupedCitiesAndCountries!["Engalnd"]
        let citiesOfEngalnd = citiesWithCountry!["Engalnd"]

        XCTAssertEqual(mockedCities?.count, citiesOfEngalnd?.count)
    }

    func testForInvalidGroupedCitiesData() {
       XCTAssertNil(self.viewModel?.groupCitiesData([]))
    }

    func testForFilterForSearchKeyWithCityName() {
        let countriesAndCities = self.viewModel?.filterForSearchKey("Lon")
        XCTAssertNotNil(countriesAndCities)
        let filteredCity = countriesAndCities?.cities[0]
        XCTAssertTrue(countriesAndCities?.cities.count == 1)
        XCTAssertEqual(filteredCity!.name, "London")
    }

    func testForFilterForSearchKeyWithCountryName() {
        let countriesAndCities = self.viewModel?.filterForSearchKey("Stat")
        XCTAssertNotNil(countriesAndCities)
        let filteredCountry = countriesAndCities?.countryNames.first
        XCTAssertEqual(filteredCountry, "United States")
    }

    func testForFilterForSearchKeyForInvalidKey() {
        let countriesAndCities = self.viewModel?.filterForSearchKey("oops")
        XCTAssertNil(countriesAndCities)
    }

    func testForFilterBasedOnCityNamesIfExistsForValidCity() {
        let countriesAndCities = self.viewModel?.filterBasedOnCityNamesIfExists(forKey: "york")
        let filteredCity = countriesAndCities?.cities.first
        XCTAssertEqual(filteredCity?.name, "New York")
    }

    func testForFilterBasedOnCityNamesIfExistsForInValidCity() {
        let countriesAndCities = self.viewModel?.filterBasedOnCityNamesIfExists(forKey: "xyz")
        let filteredCity = countriesAndCities?.cities.first
        XCTAssertNil(filteredCity)
    }

    func testForFilterBasedOnCountryNamesIfExistsForValidName() {
        let countriesAndCities = self.viewModel?.filterBasedOnCountryNameIfExists(forKey: "land")
        XCTAssertTrue(countriesAndCities?.countryNames.count == 2)
        let england = countriesAndCities?.countryNames[0]
        let netherlands = countriesAndCities?.countryNames[1]
        XCTAssertEqual(england, "England")
        XCTAssertEqual(netherlands, "Netherlands")
    }

    func testForFilterBasedOnCountryNamesIfExistsForInValidName() {
        let countriesAndCities = self.viewModel?.filterBasedOnCountryNameIfExists(forKey: "NaCl")
        XCTAssertNil(countriesAndCities)
        XCTAssertNil(countriesAndCities?.countryNames)
    }
}

class MockInvalidRequest: CityListRequest {
    typealias ModelType = CitiesAPIData

    override func baseUrl() -> String {
        return "1234ndjbsk"
    }

    override func path() -> String {
        return ""
    }

    override func method() -> String {
        return "GET"
    }

    override func data() -> Data? {
        return nil
    }

    override func error() -> NetworkError? {
        return .noData
    }
}
