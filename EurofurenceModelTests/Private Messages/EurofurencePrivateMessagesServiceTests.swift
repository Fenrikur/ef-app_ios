//
//  EurofurencePrivateMessagesServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class CapturingPrivateMessageUnreadCountObserver: PrivateMessagesServiceObserver {

    private(set) var capturedUnreadMessagesCount: Int?
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        capturedUnreadMessagesCount = unreadCount
    }

    private(set) var loadedMessages: [APIMessage] = []
    private(set) var serviceDidLoadEmptyMessagesArray = false
    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [APIMessage]) {
        loadedMessages = messages
        serviceDidLoadEmptyMessagesArray = messages.isEmpty
    }

    private(set) var toldLoadFailed = false
    func privateMessagesServiceDidFailToLoadMessages() {
        toldLoadFailed = true
    }

}

class FakePrivateMessagesService2: PrivateMessagesService2 {

    var localPrivateMessages: [APIMessage] = []

    func refreshMessages() {

    }

    private(set) fileprivate var privateMessageFetchCompletionHandler: ((PrivateMessageResult) -> Void)?
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessageFetchCompletionHandler = completionHandler
    }

    private(set) public var messageMarkedAsRead: APIMessage?
    func markMessageAsRead(_ message: APIMessage) {
        messageMarkedAsRead = message
    }

    private var privateMessageObservers = [PrivateMessagesObserver]()
    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }

    func resolvePrivateMessagesFetch(_ result: PrivateMessageResult) {
        privateMessageFetchCompletionHandler?(result)
    }

    func simulateMessagesLoaded(_ messages: [APIMessage]) {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: messages) })
    }

}

class EurofurencePrivateMessagesServiceTests: XCTestCase {

    var service: EurofurencePrivateMessagesService!
    var app: FakePrivateMessagesService2!

    override func setUp() {
        super.setUp()

        app = FakePrivateMessagesService2()
        service = EurofurencePrivateMessagesService(app: app)
    }

    func testUnreadCountEqualsExpectedCountWithUnreadMessages() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let unreadMessageCount = Int.random(upperLimit: 10)
        let messages = (0..<unreadMessageCount).map({ _ in AppDataBuilder.makeMessage(read: false) })
        app.localPrivateMessages = messages
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success(messages))

        XCTAssertEqual(unreadMessageCount, observer.capturedUnreadMessagesCount)
    }

    func testUnreadCountEqualsOneWithTwoMessagesWhereOneIsAlreadyRead() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let unreadMessage = AppDataBuilder.makeMessage(read: false)
        let readMessage = AppDataBuilder.makeMessage(read: true)
        app.localPrivateMessages = [unreadMessage, readMessage]
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success([unreadMessage, readMessage]))

        XCTAssertEqual(1, observer.capturedUnreadMessagesCount)
    }

    func testRefreshingPrivateMessagesWhenUserNotAuthenticatedShouldTellObserverLoadFailed() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.userNotAuthenticated)

        XCTAssertTrue(observer.toldLoadFailed)
    }

    func testFailedToLoadWhenRefreshingPrivateMessagesShouldTellObserverLoadFailed() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.failedToLoad)

        XCTAssertTrue(observer.toldLoadFailed)
    }

    func testLoadingPrivateMessagesSuccessfullyShouldTellObserverLoadSucceeded() {
        let messages = [AppDataBuilder.makeMessage()]
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success(messages))

        XCTAssertEqual(messages, observer.loadedMessages)
    }

    func testLoadingMessagesEmitsAppLocalMessagesWhileLoading() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let messages = [AppDataBuilder.makeMessage()]
        app.localPrivateMessages = messages
        service.refreshMessages()

        XCTAssertEqual(messages, observer.loadedMessages)
    }

    func testLoadingMessagesWhenAppDoesNotHaveLocalMessagesDoesNotEmitEmptyMessagesArrayWhileLoading() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        app.localPrivateMessages = []
        service.refreshMessages()

        XCTAssertFalse(observer.serviceDidLoadEmptyMessagesArray)
    }

    func testAddingUnreadPrivateMessageCountObserverTellsItTheNumberOfCurrentlyUnreadMessages() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        let messages = [APIMessage].random
        let expected = messages.filter({ !$0.isRead }).count
        app.simulateMessagesLoaded(messages)
        service.add(observer)

        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }

    func testAddingObserverThenRefreshProvidesMoreUnreadMessagesTellsObserver() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let messages = repeatElement(AppDataBuilder.makeMessage(read: false), count: .random(upperLimit: 10))
        let expected = messages.count
        app.localPrivateMessages = Array(messages)
        service.refreshMessages()
        app.resolvePrivateMessagesFetch(.success([]))

        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }

    func testPropogateMarkingMessageAsReadOntoCore() {
        let message = APIMessage.random
        service.markMessageAsRead(message)

        XCTAssertEqual(message, app.messageMarkedAsRead)
    }

    func testUpdateUnreadCountWhenToldMessagesChanges() {
        let observer = CapturingPrivateMessageUnreadCountObserver()
        service.add(observer)
        let messages = [APIMessage].random
        let expected = messages.filter({ !$0.isRead }).count
        app.simulateMessagesLoaded(messages)

        XCTAssertEqual(expected, observer.capturedUnreadMessagesCount)
    }

}
