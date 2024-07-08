//
//  Cities.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

struct Cities: Codable {
    var cities: [City]?
}

struct City: Codable {
    var name: String?
    var country: String?
}

struct Model {
    var name: String?
}
