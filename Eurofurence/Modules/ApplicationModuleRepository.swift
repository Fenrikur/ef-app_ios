import EurofurenceModel
import UIKit

struct ApplicationModuleRepository: ModuleRepository {
    
    let webModuleProviding: WebModuleProviding
    let rootModuleProviding: RootModuleProviding
    let tutorialModuleProviding: TutorialModuleProviding
    let preloadModuleProviding: PreloadModuleProviding
    let newsModuleProviding: NewsModuleProviding
    let scheduleModuleProviding: ScheduleModuleProviding
    let dealersModuleProviding: DealersModuleProviding
    let dealerDetailModuleProviding: DealerDetailModuleProviding
    let collectThemAllModuleProviding: CollectThemAllModuleProviding
    let messagesModuleProviding: MessagesModuleProviding
    let loginModuleProviding: LoginModuleProviding
    let messageDetailModuleProviding: MessageDetailModuleProviding
    let knowledgeListModuleProviding: KnowledgeGroupsListModuleProviding
    let knowledgeGroupEntriesModule: KnowledgeGroupEntriesModuleProviding
    let knowledgeDetailModuleProviding: KnowledgeDetailModuleProviding
    let mapsModuleProviding: MapsModuleProviding
    let mapDetailModuleProviding: MapDetailModuleProviding
    let announcementsModuleFactory: AnnouncementsModuleProviding
    let announcementDetailModuleProviding: AnnouncementDetailModuleProviding
    let eventDetailModuleProviding: EventDetailModuleProviding
    let eventFeedbackModuleProviding: EventFeedbackModuleProviding
    let additionalServicesModuleProviding: AdditionalServicesModuleProviding
    
    // swiftlint:disable function_body_length
    init(services: Services, repositories: Repositories) {
        let subtleMarkdownRenderer = SubtleDownMarkdownRenderer()
        let defaultMarkdownRenderer = DefaultDownMarkdownRenderer()
        let shareService = ActivityShareService()
        let activityFactory = PlatformActivityFactory()
        
        rootModuleProviding = RootModuleBuilder(sessionStateService: services.sessionState).build()
        tutorialModuleProviding = TutorialModuleBuilder().build()
        
        let preloadInteractor = ApplicationPreloadInteractor(refreshService: services.refresh)
        preloadModuleProviding = PreloadModuleBuilder(preloadInteractor: preloadInteractor).build()
        
        let newsInteractor = DefaultNewsInteractor(announcementsService: services.announcements,
                                                   authenticationService: services.authentication,
                                                   privateMessagesService: services.privateMessages,
                                                   daysUntilConventionService: services.conventionCountdown,
                                                   eventsService: services.events,
                                                   relativeTimeIntervalCountdownFormatter: FoundationRelativeTimeIntervalCountdownFormatter.shared,
                                                   hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                   clock: SystemClock.shared,
                                                   refreshService: services.refresh,
                                                   announcementsDateFormatter: FoundationAnnouncementDateFormatter.shared,
                                                   announcementsMarkdownRenderer: subtleMarkdownRenderer)
        newsModuleProviding = NewsModuleBuilder(newsInteractor: newsInteractor).build()
        
        let scheduleInteractor = DefaultScheduleInteractor(eventsService: services.events,
                                                           hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                           shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
                                                           shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
                                                           refreshService: services.refresh)
        scheduleModuleProviding = ScheduleModuleBuilder(interactor: scheduleInteractor).build()
        
        let defaultDealerIcon = #imageLiteral(resourceName: "defaultAvatar")
        guard let defaultDealerIconData = defaultDealerIcon.pngData() else { fatalError("Default dealer icon is not a PNG") }
        let dealersInteractor = DefaultDealersInteractor(dealersService: services.dealers, defaultIconData: defaultDealerIconData, refreshService: services.refresh)
        dealersModuleProviding = DealersModuleBuilder(interactor: dealersInteractor).build()
        
        let dealerIntentDonor = ConcreteViewDealerIntentDonor()
        let dealerInteractionRecorder = DonateIntentDealerInteractionRecorder(
            viewDealerIntentDonor: dealerIntentDonor,
            dealersService: services.dealers,
            activityFactory: activityFactory
        )
        
        let dealerDetailInteractor = DefaultDealerDetailInteractor(dealersService: services.dealers, shareService: shareService)
        dealerDetailModuleProviding = DealerDetailModuleBuilder(dealerDetailInteractor: dealerDetailInteractor, dealerInteractionRecorder: dealerInteractionRecorder).build()
        
        collectThemAllModuleProviding = CollectThemAllModuleBuilder(service: services.collectThemAll).build()
        messagesModuleProviding = MessagesModuleBuilder(authenticationService: services.authentication, privateMessagesService: services.privateMessages).build()
        loginModuleProviding = LoginModuleBuilder(authenticationService: services.authentication).build()
        messageDetailModuleProviding = MessageDetailModuleBuilder(privateMessagesService: services.privateMessages).build()
        
        let knowledgeListInteractor = DefaultKnowledgeGroupsInteractor(service: services.knowledge)
        knowledgeListModuleProviding = KnowledgeGroupsModuleBuilder(knowledgeListInteractor: knowledgeListInteractor).build()
        
        let knowledgeGroupEntriesInteractor = DefaultKnowledgeGroupEntriesInteractor(service: services.knowledge)
        knowledgeGroupEntriesModule = KnowledgeGroupEntriesModuleBuilder(interactor: knowledgeGroupEntriesInteractor).build()
        
        let knowledgeDetailSceneInteractor = DefaultKnowledgeDetailSceneInteractor(
            knowledgeService: services.knowledge,
            renderer: defaultMarkdownRenderer,
            shareService: shareService
        )
        
        knowledgeDetailModuleProviding = KnowledgeDetailModuleBuilder(knowledgeDetailSceneInteractor: knowledgeDetailSceneInteractor).build()
        
        let mapsInteractor = DefaultMapsInteractor(mapsService: services.maps)
        mapsModuleProviding = MapsModuleBuilder(interactor: mapsInteractor).build()
        
        let mapDetailInteractor = DefaultMapDetailInteractor(mapsService: services.maps)
        mapDetailModuleProviding = MapDetailModuleBuilder(interactor: mapDetailInteractor).build()
        
        let announcementsInteractor = DefaultAnnouncementsInteractor(announcementsService: services.announcements,
                                                                     announcementDateFormatter: FoundationAnnouncementDateFormatter.shared,
                                                                     markdownRenderer: subtleMarkdownRenderer)
        announcementsModuleFactory = AnnouncementsModuleBuilder(announcementsInteractor: announcementsInteractor).build()
        
        let announcementDetailInteractor = DefaultAnnouncementDetailInteractor(announcementsService: services.announcements,
                                                                               markdownRenderer: defaultMarkdownRenderer)
        announcementDetailModuleProviding = AnnouncementDetailModuleBuilder(announcementDetailInteractor: announcementDetailInteractor).build()
        
        let eventIntentDonor = ConcreteEventIntentDonor()
        let eventInteractionRecorder = SystemEventInteractionsRecorder(
            eventsService: services.events,
            eventIntentDonor: eventIntentDonor,
            activityFactory: activityFactory
        )
        
        let eventDetailInteractor = DefaultEventDetailInteractor(dateRangeFormatter: FoundationDateRangeFormatter.shared,
                                                                 eventsService: services.events,
                                                                 markdownRenderer: DefaultDownMarkdownRenderer(),
                                                                 shareService: shareService)
        eventDetailModuleProviding = EventDetailModuleBuilder(interactor: eventDetailInteractor, interactionRecorder: eventInteractionRecorder).build()
        
        let eventFeedbackPresenterFactory = EventFeedbackPresenterFactoryImpl(eventService: services.events,
                                                                              dayOfWeekFormatter: FoundationDayOfWeekFormatter.shared,
                                                                              startTimeFormatter: FoundationHoursDateFormatter.shared,
                                                                              endTimeFormatter: FoundationHoursDateFormatter.shared,
                                                                              successHaptic: CocoaTouchSuccessHaptic(),
                                                                              failureHaptic: CocoaTouchFailureHaptic(),
                                                                              successWaitingRule: ShortDelayEventFeedbackSuccessWaitingRule())
        let eventFeedbackSceneFactory = StoryboardEventFeedbackSceneFactory()
        eventFeedbackModuleProviding = EventFeedbackModuleProvidingImpl(presenterFactory: eventFeedbackPresenterFactory, sceneFactory: eventFeedbackSceneFactory)
        
        webModuleProviding = SafariWebModuleProviding()
        
        additionalServicesModuleProviding = AdditionalServicesModuleBuilder(repository: repositories.additionalServices).build()
    }
    
    func makeRootModule(_ delegate: RootModuleDelegate) {
        rootModuleProviding.makeRootModule(delegate)
    }
    
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        return tutorialModuleProviding.makeTutorialModule(delegate)
    }
    
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        return preloadModuleProviding.makePreloadModule(delegate)
    }
    
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        return newsModuleProviding.makeNewsModule(delegate)
    }
    
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        return loginModuleProviding.makeLoginModule(delegate)
    }
    
    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        return announcementsModuleFactory.makeAnnouncementsModule(delegate)
    }
    
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        return announcementDetailModuleProviding.makeAnnouncementDetailModule(for: announcement)
    }
    
    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController {
        return eventDetailModuleProviding.makeEventDetailModule(for: event, delegate: delegate)
    }
    
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        return eventFeedbackModuleProviding.makeEventFeedbackModule(for: event, delegate: delegate)
    }
    
    func makeWebModule(for url: URL) -> UIViewController {
        return webModuleProviding.makeWebModule(for: url)
    }
    
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        return messagesModuleProviding.makeMessagesModule(delegate)
    }
    
    func makeMessageDetailModule(message: MessageIdentifier) -> UIViewController {
        return messageDetailModuleProviding.makeMessageDetailModule(for: message)
    }
    
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        return scheduleModuleProviding.makeScheduleModule(delegate)
    }
    
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        return dealersModuleProviding.makeDealersModule(delegate)
    }
    
    func makeDealerDetailModule(for identifier: DealerIdentifier) -> UIViewController {
        return dealerDetailModuleProviding.makeDealerDetailModule(for: identifier)
    }
    
    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController {
        return knowledgeListModuleProviding.makeKnowledgeListModule(delegate)
    }
    
    func makeKnowledgeDetailModule(_ identifier: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController {
        return knowledgeDetailModuleProviding.makeKnowledgeListModule(identifier, delegate: delegate)
    }
    
    func makeKnowledgeGroupEntriesModule(_ knowledgeGroup: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController {
        return knowledgeGroupEntriesModule.makeKnowledgeGroupEntriesModule(knowledgeGroup, delegate: delegate)
    }
    
    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController {
        return mapsModuleProviding.makeMapsModule(delegate)
    }
    
    func makeMapDetailModule(for identifier: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        return mapDetailModuleProviding.makeMapDetailModule(for: identifier, delegate: delegate)
    }
    
    func makeCollectThemAllModule() -> UIViewController {
        return collectThemAllModuleProviding.makeCollectThemAllModule()
    }
    
    func makeAdditionalServicesModule() -> UIViewController {
        return additionalServicesModuleProviding.makeAdditionalServicesModule()
    }
    
}