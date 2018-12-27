//
//  Array+Equality.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    func equalsIgnoringOrder(_ other: [Element]) -> Bool {
        guard count == other.count else { return false }
        return other.filter(contains).count == count
    }

    func contains(elementsFrom other: Array<Element>) -> Bool {
        for item in other {
            if contains(item) == false {
                return false
            }
        }

        return true
    }

}
