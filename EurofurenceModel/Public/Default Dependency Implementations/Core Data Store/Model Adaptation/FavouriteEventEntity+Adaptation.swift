//
//  FavouriteEventEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension FavouriteEventEntity: EntityAdapting {

    typealias AdaptedType = EventIdentifier

    static func makeIdentifyingPredicate(for model: EventIdentifier) -> NSPredicate {
        return NSPredicate(format: "eventIdentifier == %@", model.rawValue)
    }

    func asAdaptedType() -> EventIdentifier {
        return EventIdentifier(eventIdentifier!)
    }

    func consumeAttributes(from value: EventIdentifier) {
        eventIdentifier = value.rawValue
    }

}
