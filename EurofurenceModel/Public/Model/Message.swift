//
//  Message.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct Message: Comparable, Equatable {

    public var identifier: String
    public var authorName: String
    public var receivedDateTime: Date
    public var subject: String
    public var contents: String
    public var isRead: Bool

    public init(identifier: String, authorName: String, receivedDateTime: Date, subject: String, contents: String, isRead: Bool) {
        self.identifier = identifier
        self.authorName = authorName
        self.receivedDateTime = receivedDateTime
        self.subject = subject
        self.contents = contents
        self.isRead = isRead
    }

    public static func <(lhs: Message, rhs: Message) -> Bool {
        return lhs.receivedDateTime.compare(rhs.receivedDateTime) == .orderedDescending
    }

    public static func ==(lhs: Message, rhs: Message) -> Bool {
        return  lhs.identifier == rhs.identifier &&
                lhs.authorName == rhs.authorName &&
                lhs.receivedDateTime == rhs.receivedDateTime &&
                lhs.subject == rhs.subject &&
                lhs.contents == rhs.contents &&
                lhs.isRead == rhs.isRead
    }

}