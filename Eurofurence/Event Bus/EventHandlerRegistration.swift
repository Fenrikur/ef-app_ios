//
//  EventConsumerRegistration.swift
//  EventBus
//
//  Created by Thomas Sherwood on 25/07/2016.
//  Copyright © 2016 ShezHsky. All rights reserved.
//

struct EventConsumerRegistration<Consumer: EventConsumer>: EventBusRegistration {

    // MARK: Properties

    let consumer: Consumer

    // MARK: EventBusRegistration

    func supports<T>(_ event: T) -> Bool {
        return event is Consumer.Event
    }

    func represents<AnotherConsumer: EventConsumer>(consumer: AnotherConsumer) -> Bool {
        guard let consumer = consumer as? Consumer else {
            return false
        }

        return self.consumer == consumer
    }

    func handle(event: Any) {
        guard let consumerEvent = event as? Consumer.Event else {
            fatalError("Consumer expected \(Consumer.Event.self), got \(event)")
        }

        consumer.consume(event: consumerEvent)
    }

}
