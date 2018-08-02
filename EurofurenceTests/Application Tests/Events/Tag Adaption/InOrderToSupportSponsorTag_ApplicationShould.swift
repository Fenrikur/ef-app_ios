//
//  InOrderToSupportSponsorTag_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class InOrderToSupportSponsorTag_ApplicationShould: XCTestCase {
    
    func testIndicateItIsSponsorEventWhenTagPresent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["sponsors_only"]
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        
        XCTAssertEqual(true, observedEvent?.isSponsorOnly)
    }
    
    func testNotIndicateItIsSponsorEventWhenTagPresent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = []
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        
        XCTAssertEqual(false, observedEvent?.isSponsorOnly)
    }
    
}
