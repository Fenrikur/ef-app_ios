//
//  WhenFavouritingEventViewModel_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFavouritingEventViewModel_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheEventServiceToFavouriteTheEventByIdentifier() {
        let event = Event2.random
        let context = EventDetailInteractorTestBuilder().build(for: event)
        context.viewModel?.favourite()
        
        XCTAssertEqual(event.identifier, context.eventsService.favouritedEventIdentifier)
    }
    
}
