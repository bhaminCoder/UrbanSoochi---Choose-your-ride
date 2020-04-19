//
//  Extensions.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 19/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

extension String {

    func isASubSetOf(givenText: String) -> Bool {
        let inputText: NSString = NSString(string: givenText.replacingOccurrences(of: " ", with: ""))
        let range = inputText.range(of: self, options: .caseInsensitive)
        return range.location != NSNotFound
    }
}

extension Dictionary {

    var sortedKeyPaths: [String] {
        let keyPaths = self.keys.compactMap({String(describing: $0)})
        return keyPaths.sorted()
    }
}

extension Sequence {

    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        return Dictionary(grouping: self, by: key)
    }
}
