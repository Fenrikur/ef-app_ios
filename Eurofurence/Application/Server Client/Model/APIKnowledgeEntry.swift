//
//  APIKnowledgeEntry.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct APIKnowledgeEntry: Comparable, Equatable {

    public var identifier: String
    public var groupIdentifier: String
    public var title: String
    public var order: Int
    public var text: String
    public var links: [APILink]
    public var imageIdentifiers: [String]

    public init(identifier: String, groupIdentifier: String, title: String, order: Int, text: String, links: [APILink], imageIdentifiers: [String]) {
        self.identifier = identifier
        self.groupIdentifier = groupIdentifier
        self.title = title
        self.order = order
        self.text = text
        self.links = links
        self.imageIdentifiers = imageIdentifiers
    }

    public static func <(lhs: APIKnowledgeEntry, rhs: APIKnowledgeEntry) -> Bool {
        return lhs.title < rhs.title
    }

}
