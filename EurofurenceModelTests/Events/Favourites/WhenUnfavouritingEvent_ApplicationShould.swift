//
//  WhenUnfavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenUnfavouritingEvent_ApplicationShould: XCTestCase {

    func testTellTheDataStoreToDeleteTheEventIdentifier() {
        let context = ApplicationTestBuilder().build()
        let identifier = EventIdentifier.random
        context.eventsService.favouriteEvent(identifier: identifier)
        context.eventsService.unfavouriteEvent(identifier: identifier)

        XCTAssertTrue(context.dataStore.didDeleteFavouriteEvent(identifier))
    }

    func testTellObserversTheEventHasBeenUnfavourited() {
        let context = ApplicationTestBuilder().build()
        let identifier = EventIdentifier.random
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.eventsService.favouriteEvent(identifier: identifier)
        context.eventsService.unfavouriteEvent(identifier: identifier)

        XCTAssertFalse(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellTheNotificationServiceToRemoveTheScheduledNotification() {
        let context = ApplicationTestBuilder().build()
        let identifier = EventIdentifier.random
        context.eventsService.favouriteEvent(identifier: identifier)
        context.eventsService.unfavouriteEvent(identifier: identifier)

        XCTAssertEqual(identifier, context.notificationScheduler.capturedEventIdentifierToRemoveNotification)
    }

}
