//
//  WhenSyncingWhileLoggedIn.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSyncingWhileLoggedIn: XCTestCase {

    func testObserversArePassedLoadedMessages() {
        let expected = [MessageCharacteristics].random.sorted()
        let context = ApplicationTestBuilder().build()
        context.loginSuccessfully()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)
        context.api.simulateMessagesResponse(response: expected)

        MessageAssertion()
            .assertMessages(observer.observedMessages, characterisedBy: expected)
    }

    func testAddingAnotherObserverIsPassedLoadedMessages() {
        let expected = [MessageCharacteristics].random.sorted()
        let context = ApplicationTestBuilder().build()
        context.loginSuccessfully()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)
        context.api.simulateMessagesResponse(response: expected)
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)

        MessageAssertion()
            .assertMessages(observer.observedMessages, characterisedBy: expected)
    }

    func testTheSyncDoesNotFinishUntilMessagesHaveLoaded() {
        let context = ApplicationTestBuilder().build()
        context.loginSuccessfully()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        var didFinishBeforeMessagesLoaded = false
        context.refreshLocalStore { _ in didFinishBeforeMessagesLoaded = true }
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertFalse(didFinishBeforeMessagesLoaded)
    }

}
