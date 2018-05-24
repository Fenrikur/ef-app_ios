//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum LogoutResult {
    case success
    case failure
}

enum PrivateMessageResult {
    case success([Message])
    case failedToLoad
    case userNotAuthenticated
}

class EurofurenceApplication: EurofurenceApplicationProtocol {

    static var shared: EurofurenceApplicationProtocol = EurofurenceApplicationBuilder().build()

    private let eventBus = EventBus()
    private let userPreferences: UserPreferences
    private let dataStore: EurofurenceDataStore
    private let pushPermissionsRequester: PushPermissionsRequester
    private let pushPermissionsStateProviding: PushPermissionsStateProviding
    private let clock: Clock
    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController
    private let authenticationCoordinator: UserAuthenticationCoordinator
    private let privateMessagesController: PrivateMessagesController
    private let syncAPI: SyncAPI
    private let imageAPI: ImageAPI
    private let conventionCountdownController: ConventionCountdownController
    private var syncResponse: APISyncResponse?
    private var knowledgeGroups = [KnowledgeGroup2]()
    private var announcements = [Announcement2]()
    private var events = [Event2]()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private let imageCache = ImagesCache()

    init(userPreferences: UserPreferences,
         dataStore: EurofurenceDataStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         pushPermissionsRequester: PushPermissionsRequester,
         pushPermissionsStateProviding: PushPermissionsStateProviding,
         clock: Clock,
         credentialStore: CredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI,
         syncAPI: SyncAPI,
         imageAPI: ImageAPI,
         dateDistanceCalculator: DateDistanceCalculator,
         conventionStartDateRepository: ConventionStartDateRepository,
         significantTimeChangeEventSource: SignificantTimeChangeEventSource,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval) {
        self.userPreferences = userPreferences
        self.dataStore = dataStore
        self.pushPermissionsRequester = pushPermissionsRequester
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        self.clock = clock
        self.syncAPI = syncAPI
        self.imageAPI = imageAPI
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow

        if pushPermissionsStateProviding.requestedPushNotificationAuthorization {
            pushPermissionsRequester.requestPushPermissions()
        }

        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(eventBus: eventBus,
                                                                                            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration)
        privateMessagesController = PrivateMessagesController(eventBus: eventBus, privateMessagesAPI: privateMessagesAPI)
        authenticationCoordinator = UserAuthenticationCoordinator(eventBus: eventBus,
                                                                  clock: clock,
                                                                  credentialStore: credentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)

        conventionCountdownController = ConventionCountdownController(significantTimeChangeEventSource: significantTimeChangeEventSource,
                                                                      conventionStartDateRepository: conventionStartDateRepository,
                                                                      dateDistanceCalculator: dateDistanceCalculator,
                                                                      clock: clock)
    }

    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {
        dataStore.resolveContentsState { (state) in
            switch state {
            case .empty:
                completionHandler(.absent)

            case .present:
                if self.userPreferences.refreshStoreOnLaunch {
                    completionHandler(.stale)
                } else {
                    completionHandler(.available)
                }
            }
        }
    }

    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        authenticationCoordinator.login(arguments, completionHandler: completionHandler)
    }

    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        authenticationCoordinator.logout(completionHandler: completionHandler)
    }

    func requestPermissionsForPushNotifications() {
        pushPermissionsRequester.requestPushPermissions()
        pushPermissionsStateProviding.attemptedPushAuthorizationRequest()
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationRegistrationSucceeded(deviceToken: deviceToken))
    }

    var localPrivateMessages: [Message] { return privateMessagesController.localPrivateMessages }

    func add(_ observer: PrivateMessagesObserver) {
        privateMessagesController.add(observer)
    }

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessagesController.fetchPrivateMessages(completionHandler: completionHandler)
    }

    func markMessageAsRead(_ message: Message) {
        privateMessagesController.markMessageAsRead(message)
    }

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        authenticationCoordinator.retrieveCurrentUser(completionHandler: completionHandler)
    }

    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        dataStore.fetchKnowledgeGroups { (persistedGroups) in
            if let persistedGroups = persistedGroups {
                completionHandler(persistedGroups.sorted())
            } else {
                completionHandler(self.knowledgeGroups)
            }
        }
    }

    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        enum SyncError: Error {
            case failedToLoadResponse
        }

        let progress = Progress()

        syncAPI.fetchLatestData { (response) in
            if let response = response {
                self.syncResponse = response

                let posterImageIDs = response.events.changed.map({ $0.posterImageId })
                progress.totalUnitCount = Int64(posterImageIDs.count)

                var pendingPosterIDs = posterImageIDs
                posterImageIDs.forEach({ (posterID) in
                    self.imageAPI.fetchImage(identifier: posterID, completionHandler: { (posterData) in
                        guard let idx = pendingPosterIDs.index(of: posterID) else { return }
                        pendingPosterIDs.remove(at: idx)
                        self.imageCache[posterID] = posterData

                        var completedUnitCount = progress.completedUnitCount
                        completedUnitCount += 1
                        progress.completedUnitCount = completedUnitCount

                        if pendingPosterIDs.isEmpty {
                            self.updateEvents(from: response)
                            self.updateKnowledgeGroups(from: response)
                            self.updateAnnouncements(from: response)

                            self.dataStore.performTransaction({ (transaction) in
                                transaction.saveKnowledgeGroups(self.knowledgeGroups)
                                transaction.saveAnnouncements(self.announcements)
                            })

                            self.announcementsObservers.forEach({ $0.eurofurenceApplicationDidChangeUnreadAnnouncements(to: self.announcements) })

                            let runningEvents = self.makeRunningEvents()
                            let upcomingEvents = self.makeUpcomingEvents()
                            self.eventsObservers.forEach({ (observer) in
                                observer.eurofurenceApplicationDidUpdateRunningEvents(to: runningEvents)
                                observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: upcomingEvents)
                            })

                            self.privateMessagesController.fetchPrivateMessages { (_) in completionHandler(nil) }
                        }
                    })
                })
            } else {
                completionHandler(SyncError.failedToLoadResponse)
            }
        }

        return progress
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "mailto" {
            return .externalURL(url)
        }

        return .web(url)
    }

    private var announcementsObservers = [AnnouncementsServiceObserver]()
    func add(_ observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeUnreadAnnouncements(to: announcements)
        announcementsObservers.append(observer)
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        conventionCountdownController.observeDaysUntilConvention(using: observer)
    }

    func add(_ observer: AuthenticationStateObserver) {
        authenticationCoordinator.add(observer)
    }

    private var eventsObservers = [EventsServiceObserver]()
    func add(_ observer: EventsServiceObserver) {
        eventsObservers.append(observer)
        observer.eurofurenceApplicationDidUpdateRunningEvents(to: makeRunningEvents())
        observer.eurofurenceApplicationDidUpdateUpcomingEvents(to: [])
    }

    private func makeRunningEvents() -> [Event2] {
        let now = clock.currentDate
        return events.filter { (event) -> Bool in
            let range = DateInterval(start: event.startDate, end: event.endDate)
            return range.contains(now)
        }
    }

    private func makeUpcomingEvents() -> [Event2] {
        let now = clock.currentDate
        let range = DateInterval(start: now, end: now.addingTimeInterval(timeIntervalForUpcomingEventsSinceNow))
        return events.filter { (event) -> Bool in
            return event.startDate > now && range.contains(event.startDate)
        }
    }

    private func updateAnnouncements(from response: APISyncResponse) {
        let sortedAnnouncements = response.announcements.changed.sorted(by: { (first, second) -> Bool in
            return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
        })

        announcements = Announcement2.fromServerModels(sortedAnnouncements)
    }

    private func updateKnowledgeGroups(from response: APISyncResponse) {
        knowledgeGroups = KnowledgeGroup2.fromServerModels(groups: response.knowledgeGroups.changed,
                                                           entries: response.knowledgeEntries.changed)
    }

    private func updateEvents(from response: APISyncResponse) {
        events = response.events.changed.flatMap({ (event) -> Event2? in
            guard let room = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier }) else { return nil }
            guard let track = response.tracks.changed.first(where: { $0.trackIdentifier == event.trackIdentifier }) else { return nil }

            return Event2(title: event.title,
                          abstract: event.abstract,
                          room: Room(name: room.name),
                          track: Track(name: track.name),
                          hosts: event.panelHosts,
                          startDate: event.startDateTime,
                          endDate: event.endDateTime,
                          eventDescription: event.eventDescription,
                          posterGraphicPNGData: self.imageCache[event.posterImageId])
        })
    }

}
