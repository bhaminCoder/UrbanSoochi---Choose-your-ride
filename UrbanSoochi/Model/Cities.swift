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

    func toTestAI() {
        let items = [1, 2, 3, 4, 5, 6, 7]
        var new items = items.filter{$0 == 6}
    }
}
