import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
    }

    private func simulateSyncPushNotification(_ handler: @escaping (NotificationContent) -> Void) {
        let payload: [String: String] = ["event": "sync"]
        context.notificationsService.handleNotification(payload: payload, completionHandler: handler)
    }

    func testRefreshTheLocalStore() {
        simulateSyncPushNotification { (_) in }
        XCTAssertTrue(context.api.didBeginSync)
    }

    func testProvideSyncSuccessResultWhenDownloadSucceeds() {
        var result: NotificationContent?
        simulateSyncPushNotification { result = $0 }
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(.successfulSync, result)
    }

    func testProideSyncFailedResponseWhenDownloadFails() {
        var result: NotificationContent?
        simulateSyncPushNotification { result = $0 }
        context.api.simulateUnsuccessfulSync()

        XCTAssertEqual(.failedSync, result)
    }

}
