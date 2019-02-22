//
//  SchedulePresenterPhotoshootIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterPhotoshootIconBindingTests: XCTestCase {

    func testShowThePhotoshootIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isPhotoshootEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertTrue(component.didShowPhotoshootStageEventIndicator)
        XCTAssertFalse(component.didHidePhotoshootStageEventIndicator)
    }

    func testHideThePhotoshootIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isPhotoshootEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertFalse(component.didShowPhotoshootStageEventIndicator)
        XCTAssertTrue(component.didHidePhotoshootStageEventIndicator)
    }

}
