//
//  SchedulePresenterKageIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterKageIconBindingTests: XCTestCase {

    func testShowTheKageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isKageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.kageIconVisibility, .visible)
    }

    func testHideTheKageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isKageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.kageIconVisibility, .hidden)
    }

}
