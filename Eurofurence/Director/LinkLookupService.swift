//
//  LinkLookupService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol LinkLookupService {

    func lookupContent(for link: Link) -> LinkContentLookupResult?

}

enum LinkContentLookupResult: Equatable {

    case web(URL)

    static func ==(lhs: LinkContentLookupResult, rhs: LinkContentLookupResult) -> Bool {
        switch (lhs, rhs) {
        case (.web(let l), .web(let r)):
            return l == r
        }
    }
}
