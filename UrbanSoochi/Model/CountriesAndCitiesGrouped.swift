//
//  CountriesAndCitiesGrouped.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 19/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

typealias CitiesGroupedByCountry = [String: [City]]

struct CountriesAndCitiesGrouped {
    var cities: [City]
    var countryNames: [String]
    var groupedCountriesAndCitiesGrouped: CitiesGroupedByCountry
}
