//
//  CitiesListViewModel.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

let allowedContactFieldCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted

class CitiesListViewModel {

    var citiesGroupedByCountries: CountriesAndCitiesGrouped?

    // Makes an API call with `CityListRequest` object to get a structured group of citiesGroupedByCountries
    // Else, throws an error if fails
    func getListOfCities(request: CityListRequest = CityListRequest(),
                                completion: @escaping (_ success: Bool, _ error: NetworkError?) -> Void) {
        APIRequestManager.executeAPIRequest(request) { (data, error) in
            if let data = data,
                let cities = self.decodeCitiesData(data: data) {
                self.citiesGroupedByCountries = self.groupCitiesData(cities)
                completion(true, nil)
            }

            if let error = error {
                completion(false, error)
            }
        }
    }

    //Decodes the API data with respective model type i.e., `CountriesAndCitiesGrouped`
    func decodeCitiesData(data: Data) -> [City]? {
        guard let cityListData = APIRequestManager.toDecodedModelData(data, modelType: Cities.self),
            let cities = cityListData.cities else { return nil }
        return cities
    }

    //A City does not belong without a name and a country, hence filtring out the valid cities for display
    func validSortedCities(_ cities: [City]) -> [City] {
        let validCities = cities.filter { (city) -> Bool in
            guard let cityName = city.name, let countryName = city.country,
                !cityName.isEmpty, !countryName.isEmpty else { return false }
            return true
        }
        return validCities.sortedByName
    }

    //Groups list of cities with country names and updates the `CountriesAndCitiesGrouped` datasource
    func groupCitiesData(_ cities: [City]) -> CountriesAndCitiesGrouped? {
        if !cities.isEmpty {
            let citiesSorted = self.validSortedCities(cities)
            let countryNames = citiesSorted.groupedByCountry.sortedKeyPaths
            return CountriesAndCitiesGrouped(cities: citiesSorted, countryNames: countryNames,
                                                groupedCountriesAndCitiesGrouped: citiesSorted.groupedByCountry)
        }
        return nil
    }

    //Returns a collection of matching items if matches with the given searchKey
    func matchingCollectionForKey(_ key: String, data: [String]) -> [String] {
        return data.filter { (text) -> Bool in
            return key.isASubSetOf(givenText: text)
        }
    }

    //Filters for cities and countries based on given serachKey if either of which exists
    // Else returns nil
    func filterForSearchKey(_ key: String) -> CountriesAndCitiesGrouped? {
         if let filteredByCities = self.filterBasedOnCityNamesIfExists(forKey: key) {
             return filteredByCities
         } else {
             return self.filterBasedOnCountryNameIfExists(forKey: key)
         }
    }

    func filterBasedOnCityNamesIfExists(forKey searchKey: String) -> CountriesAndCitiesGrouped? {

        guard let citiesGroupedByCountries = self.citiesGroupedByCountries else { return nil }

        let cities = citiesGroupedByCountries.cities
        let cityNames = cities.compactMap({$0.name})

        let filteredCityNames = self.matchingCollectionForKey(searchKey, data: cityNames)

        //If no city name is matching with search text, search for matching text in countries
        if filteredCityNames.count > 0 {
            let matchingCities = cities.filter({filteredCityNames.contains($0.name ?? "")})
            return self.groupCitiesData(matchingCities)
        }
        return nil
    }

    func filterBasedOnCountryNameIfExists(forKey searchKey: String) -> CountriesAndCitiesGrouped? {
        guard let citiesGroupedByCountries = self.citiesGroupedByCountries else { return nil}

        let groupedCountriesAndCitiesGroupedFiltered = citiesGroupedByCountries.groupedCountriesAndCitiesGrouped.filter({
            (countryName, _) in
            return searchKey.isASubSetOf(givenText: countryName)
        })

        guard !groupedCountriesAndCitiesGroupedFiltered.isEmpty else { return nil }
        return CountriesAndCitiesGrouped(cities: citiesGroupedByCountries.cities,
                                   countryNames: groupedCountriesAndCitiesGroupedFiltered.sortedKeyPaths,
                              groupedCountriesAndCitiesGrouped: groupedCountriesAndCitiesGroupedFiltered)
    }
}

extension Array where Element == City {

    var groupedByCountry: CitiesGroupedByCountry {
        return self.group(by: {$0.country ?? ""})
    }

    var sortedByName: [City] {
        return self.sorted { (previousCity, nextCity) -> Bool in
            guard let previousCityName = previousCity.name,
                let nextCityName = nextCity.name else { return false }
               return previousCityName < nextCityName
        }
    }
}
