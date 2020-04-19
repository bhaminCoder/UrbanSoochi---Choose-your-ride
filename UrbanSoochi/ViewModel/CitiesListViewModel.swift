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

    var countriesAndCities: CountriesAndCities?

    func getListOfCities(request: CityListRequest = CityListRequest(),
                                completion: @escaping (_ success: Bool, _ error: NetworkError?) -> Void) {
        APIRequestManager.executeAPIRequest(request) { (data, error) in
            if let data = data,
                let cities = self.decodeCitiesData(data: data) {
                self.countriesAndCities = self.groupCitiesData(cities)
                completion(true, nil)
            }

            if let error = error {
                completion(false, error)
            }
        }
    }

    func decodeCitiesData(data: Data) -> [City]? {
        guard let cityListData = APIRequestManager.toDecodedModelData(data, modelType: CitiesAPIData.self),
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

    func groupCitiesData(_ cities: [City]) -> CountriesAndCities? {
        if !cities.isEmpty {
            let citiesSorted = self.validSortedCities(cities)
            let countryNames = citiesSorted.groupedByCountry.sortedKeyPaths
            return CountriesAndCities(cities: citiesSorted, countryNames: countryNames,
                                                citiesGroupedByCountry: citiesSorted.groupedByCountry)
        }
        return nil
    }

    func matchingCollectionForKey(_ key: String, data: [String]) -> [String] {
        return data.filter { (text) -> Bool in
            return key.isASubSetOf(givenText: text)
        }
    }

    func filterForSearchKey(_ key: String) -> CountriesAndCities? {
         if let filteredByCities = self.filterBasedOnCityNamesIfExists(forKey: key) {
             return filteredByCities
         } else {
             return self.filterBasedOnCountryNameIfExists(forKey: key)
         }
    }

    func filterBasedOnCityNamesIfExists(forKey searchKey: String) -> CountriesAndCities? {

        guard let countriesAndCities = self.countriesAndCities else { return nil }

        let cities = countriesAndCities.cities
        let cityNames = cities.compactMap({$0.name})

        let filteredCityNames = self.matchingCollectionForKey(searchKey, data: cityNames)

        //If no city name is matching with search text, search for matching text in countries
        if filteredCityNames.count > 0 {
            let matchingCities = cities.filter({filteredCityNames.contains($0.name ?? "")})
            return self.groupCitiesData(matchingCities)
        }
        return nil
    }

    func filterBasedOnCountryNameIfExists(forKey searchKey: String) -> CountriesAndCities? {
        guard let countriesAndCities = self.countriesAndCities else { return nil}

        let citiesGroupedByCountryFiltered = countriesAndCities.citiesGroupedByCountry.filter({
            (countryName, _) in
            return searchKey.isASubSetOf(givenText: countryName)
        })

        guard !citiesGroupedByCountryFiltered.isEmpty else { return nil }
        return CountriesAndCities(cities: countriesAndCities.cities,
                                   countryNames: citiesGroupedByCountryFiltered.sortedKeyPaths,
                              citiesGroupedByCountry: citiesGroupedByCountryFiltered)
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
