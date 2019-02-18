//
//  MessageAssertion.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

class MessageAssertion: EntityAssertion {

    func assertMessages(_ messages: [MessageEntity], characterisedBy characteristics: [MessageEntity]) {
        guard messages.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual messages")
            return
        }

        var sortedCharacteristics = characteristics.sorted { (first, second) -> Bool in
            return first.receivedDateTime.compare(second.receivedDateTime) == .orderedDescending
        }

        for (idx, message) in messages.enumerated() {
            let characteristic = sortedCharacteristics[idx]
            assertMessage(message, characterisedBy: characteristic)
        }
    }

    func assertMessage(_ message: MessageEntity, characterisedBy characteristic: MessageEntity) {
        assert(message.identifier, isEqualTo: characteristic.identifier)
        assert(message.authorName, isEqualTo: characteristic.authorName)
        assert(message.receivedDateTime, isEqualTo: characteristic.receivedDateTime)
        assert(message.subject, isEqualTo: characteristic.subject)
        assert(message.contents, isEqualTo: characteristic.contents)
        assert(message.isRead, isEqualTo: characteristic.isRead)
    }

}
