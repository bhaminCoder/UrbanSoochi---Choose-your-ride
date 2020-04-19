//
//  NetworkError.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 18/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

public enum NetworkError: Error {

    case noData
    case invalidURL

    public var localizedDescription: String {
        switch self {
        case .noData:
            return ErrorMessage.noDataError
        case .invalidURL:
            return ErrorMessage.invalidUrlError
        }
    }
}

/// Alert Messages to be shown in the app
struct ErrorMessage {
    static let noDataError = "Unexpected Error - No data found"
    static let invalidUrlError = "URL is invalid"
}
