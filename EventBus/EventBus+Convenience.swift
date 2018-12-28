//
//  EventBus+Convenience.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public extension EventBus {

    public func subscribe<T>(_ block: @escaping (T) -> Void) {
        let consumer = BlockEventConsumer(block: block)
        subscribe(consumer: consumer)
    }

}
