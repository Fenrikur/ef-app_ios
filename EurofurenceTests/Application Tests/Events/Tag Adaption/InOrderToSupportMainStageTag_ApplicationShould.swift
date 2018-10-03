//
//  InOrderToSupportMainStageTag_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class InOrderToSupportMainStageTag_ApplicationShould: XCTestCase {
    
    func testIndicateItIsMainStageEventWhenTagPresent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = ["main_stage"]
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        
        XCTAssertEqual(true, observedEvent?.isMainStage)
    }
    
    func testNotIndicateItIsMainStageEventWhenTagNotPresent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.tags = []
        syncResponse.events.changed = [event]
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let eventsObserver = CapturingEventsServiceObserver()
        context.application.add(eventsObserver)
        let observedEvent = eventsObserver.allEvents.first
        
        XCTAssertEqual(false, observedEvent?.isMainStage)
    }
    
}
