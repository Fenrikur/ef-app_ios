import EurofurenceApplicationSession
import EurofurenceModel
import Foundation
import UIKit

class Application {

    static let instance: Application = Application()
    private let session: EurofurenceSession
    private let backgroundFetcher: BackgroundFetchService
    private let notificationScheduleController: NotificationScheduleController
    private let reviewPromptController: ReviewPromptController
    private var principalWindowController: PrincipalWindowAssembler?
    private let urlOpener: URLOpener
    
    static func assemble() {
        _ = instance
    }
    
    static func storeRemoteNotificationsToken(_ deviceToken: Data) {
        instance.session.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }
    
    static func executeBackgroundFetch(
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        instance.backgroundFetcher.executeFetch(completionHandler: completionHandler)
    }
    
    static func openNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        instance.principalWindowController?.route(NotificationContentRepresentation(userInfo: userInfo))
    }
    
    static func resume(activity: NSUserActivity) {
        let activityDescription = SystemActivityDescription(userActivity: activity)
        let contentRepresentation = UserActivityContentRepresentation(activity: activityDescription)
        instance.principalWindowController?.route(contentRepresentation)
    }
    
    // swiftlint:disable function_body_length
    private init() {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: .currentConvention)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(
            buildConfiguration: buildConfiguration,
            appVersion: BundleAppVersionProviding.shared,
            conventionIdentifier: .currentConvention,
            firebaseAdapter: FirebaseMessagingAdapter(),
            fcmRegistration: fcmRegistration
        )
        
        let remoteConfigurationLoader = FirebaseRemoteConfigurationLoader()
        let conventionStartDateRepository = RemotelyConfiguredConventionStartDateRepository(
            remoteConfigurationLoader: remoteConfigurationLoader
        )
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: .currentConvention,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: CIDBasedShareableURLFactory(conventionIdentifier: .currentConvention)
        )
        
        urlOpener = AppURLOpener()
        session = EurofurenceSessionBuilder(mandatory: mandatory)
            .with(remoteNotificationsTokenRegistration)
            .with(ApplicationSignificantTimeChangeAdapter())
            .with(urlOpener)
            .with(ApplicationLongRunningTaskManager())
            .with(UIKitMapCoordinateRender())
            .with(UpdateRemoteConfigRefreshCollaboration(remoteConfigurationLoader: remoteConfigurationLoader))
            .build()
        
        backgroundFetcher = BackgroundFetchService(refreshService: session.services.refresh)
        
        // TODO: Source from preferences/Firebase
        let upcomingEventReminderInterval: TimeInterval = 900
        notificationScheduleController = NotificationScheduleController(
            eventsService: session.services.events,
            notificationScheduler: UserNotificationsScheduler(),
            hoursDateFormatter: FoundationHoursDateFormatter.shared,
            upcomingEventReminderInterval: upcomingEventReminderInterval,
            clock: SystemClock.shared
        )
        
        reviewPromptController = ReviewPromptController(
            config: .default,
            reviewPromptAction: StoreKitReviewPromptAction(),
            versionProviding: BundleAppVersionProviding.shared,
            reviewPromptAppVersionRepository: UserDefaultsReviewPromptAppVersionRepository(),
            appStateProviding: ApplicationAppStateProviding(),
            eventsService: session.services.events
        )
    }
    
    func configurePrincipalScene(window: UIWindow) {
        principalWindowController = PrincipalWindowAssembler(
            window: window,
            services: session.services,
            repositories: session.repositories,
            urlOpener: urlOpener
        )
    }

}
