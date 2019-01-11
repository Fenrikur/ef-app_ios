//
//  MapEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension MapEntity: EntityAdapting {

    typealias AdaptedType = APIMap

    func asAdaptedType() -> APIMap {
        let entries = ((self.entries as? Set<MapEntryEntity>) ?? Set())
        return APIMap(identifier: identifier!,
                      imageIdentifier: imageIdentifier!,
                      mapDescription: mapDescription!,
                      entries: entries.map({ $0.asAdaptedType() }))
    }

    func consumeAttributes(from value: APIMap) {
        identifier = value.identifier
        imageIdentifier = value.imageIdentifier
        mapDescription = value.mapDescription
    }

}

extension MapEntryEntity: EntityAdapting {

    typealias AdaptedType = APIMap.Entry

    func asAdaptedType() -> APIMap.Entry {
        let links = ((self.links as? Set<MapEntryLinkEntity>) ?? Set())
        return APIMap.Entry(identifier: identifier.or(""),
                            x: Int(x),
                            y: Int(y),
                            tapRadius: Int(tapRadius),
                            links: links.map({ $0.asAdaptedType() }))
    }

    func consumeAttributes(from value: APIMap.Entry) {
        identifier = value.identifier
        x = Int64(value.x)
        y = Int64(value.y)
        tapRadius = Int64(value.tapRadius)
    }

}

extension MapEntryLinkEntity: EntityAdapting {

    typealias AdaptedType = APIMap.Entry.Link

    func asAdaptedType() -> APIMap.Entry.Link {
        return APIMap.Entry.Link(type: APIMap.Entry.Link.FragmentType(rawValue: Int(type))!,
                                 name: name,
                                 target: target!)
    }

    func consumeAttributes(from value: APIMap.Entry.Link) {
        type = Int16(value.type.rawValue)
        name = value.name
        target = value.target
    }

}
