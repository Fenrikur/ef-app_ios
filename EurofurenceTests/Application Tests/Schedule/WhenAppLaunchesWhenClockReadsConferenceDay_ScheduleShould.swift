//
//  WhenAppLaunchesWhenClockReadsConferenceDay_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAppLaunchesWhenClockReadsConferenceDay_ScheduleShould: XCTestCase {
    
    func testChangeToExpectedConDay() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(randomDay.date).with(dataStore).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let expected = context.makeExpectedDay(from: randomDay)
        
        XCTAssertEqual(expected, delegate.capturedCurrentDay)
    }
    
    func testPermitFuzzyMatchingAgainstHoursMinutesAndSecondsWithinDay() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let randomDay = syncResponse.conferenceDays.changed.randomElement().element
        var randomDayComponents = Calendar.current.dateComponents(in: TimeZone(abbreviation: "GMT")!, from: randomDay.date)
        randomDayComponents.hour = .random(upperLimit: 23)
        randomDayComponents.minute = .random(upperLimit: 59)
        randomDayComponents.second = .random(upperLimit: 59)
        let sameDayAsRandomDayButDifferentTime = randomDayComponents.date!
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(sameDayAsRandomDayButDifferentTime).with(dataStore).build()
        let schedule = context.application.makeEventsSchedule()
        let delegate = CapturingEventsScheduleDelegate()
        schedule.setDelegate(delegate)
        let expected = context.makeExpectedDay(from: randomDay)
        
        XCTAssertEqual(expected, delegate.capturedCurrentDay)
    }
    
}
