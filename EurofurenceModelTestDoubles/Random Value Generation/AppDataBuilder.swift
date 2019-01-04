//
//  AppDataBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

public struct AppDataBuilder {

    public static func makeMessage(identifier: String = "Identifier",
                                   authorName: String = "Author",
                                   receivedDateTime: Date = Date(),
                                   subject: String = "Subject",
                                   contents: String = "Contents",
                                   read: Bool = false) -> APIMessage {
        return APIMessage(identifier: identifier,
                       authorName: authorName,
                       receivedDateTime: receivedDateTime,
                       subject: subject,
                       contents: contents,
                       isRead: read)
    }

    public static func makeRandomNumberOfMessages() -> [APIMessage] {
        return (0...Int.random(upperLimit: 10)).map { (number) in
            return makeMessage(identifier: String(describing: number),
                               authorName: "Author \(number)",
                receivedDateTime: Date(),
                subject: "Subject \(number)",
                contents: "Contents \(number)",
                read: number % 2 == 0)
        }
    }

}
