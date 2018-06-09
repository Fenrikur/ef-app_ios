//
//  WhenApplicationInitialises_WithAnnouncementsSavedToStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenApplicationInitialises_WithAnnouncementsSavedToStore: XCTestCase {
    
    func testTheEventsAreProvidedToTheObserver() {
        let dataStore = CapturingEurofurenceDataStore()
        let announcements = [APIAnnouncement].random
        dataStore.performTransaction { (transaction) in
            transaction.saveAnnouncements(announcements)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        let expected = context.expectedAnnouncements(from: announcements)
        
        XCTAssertEqual(expected, observer.allAnnouncements)
    }
    
}
