//
//  Cities.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

typealias CitiesGroupedByCountry = [String: [City]]

struct CitiesAPIData: Codable {
    var cities: [City]?
    var countriesList: [String]?
}

struct CountriesAndCities {
    var cities: [City]
    var countryNames: [String]
    var citiesGroupedByCountry: CitiesGroupedByCountry
}
