import EurofurenceModel
import UIKit

struct NotificationServiceFetchResultAdapter {

    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func handleRemoteNotification(_ payload: [AnyHashable: Any],
                                  completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let castedPayloadKeysAndValues: [(String, String)] = payload.compactMap { (key, value) -> (String, String)? in
            guard let stringKey = key as? String, let stringValue = value as? String else { return nil }
            return (stringKey, stringValue)
        }

        let castedPayload: [String: String] = castedPayloadKeysAndValues.reduce(into: [String: String](), { $0[$1.0] = $1.1 })

        notificationService.handleNotification(payload: castedPayload) { (content) in
            switch content {
            case .successfulSync:
                completionHandler(.newData)

            case .failedSync:
                completionHandler(.failed)

            case .announcement:
                completionHandler(.newData)

            case .event:
                completionHandler(.noData)

            case .invalidatedAnnouncement:
                completionHandler(.noData)

            case .unknown:
                completionHandler(.noData)
            }
        }
    }

}
