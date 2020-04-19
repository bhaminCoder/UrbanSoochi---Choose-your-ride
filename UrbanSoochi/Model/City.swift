//
//  City.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 19/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

struct City: Codable {
    var name: String?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    var temperature: Double?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.country = try values.decodeIfPresent(String.self, forKey: .country)
        self.latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        self.temperature = try values.decodeIfPresent(Double.self, forKey: .temperature)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case country
        case latitude = "lat"
        case longitude = "long"
        case temperature = "temp"
    }
}

extension City {

    init(name: String?, country: String?,
         latitude: Double?, longitude: Double?, temperature: Double?) {
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.temperature = temperature
    }
}
