//
//  WhenPerformingSyncThatFails.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPerformingSyncThatFails: XCTestCase {
    
    func testTheCompletionHandlerIsInvokedWithAnError() {
        let context = ApplicationTestBuilder().build()
        var error: Error?
        context.refreshLocalStore { error = $0 }
        context.syncAPI.simulateUnsuccessfulSync()
        
        XCTAssertNotNil(error)
    }
    
}
