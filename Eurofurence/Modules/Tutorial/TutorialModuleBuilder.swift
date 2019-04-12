import EurofurenceModel

class TutorialModuleBuilder {

    private var tutorialSceneFactory: TutorialSceneFactory
    private var presentationAssets: PresentationAssets
    private var alertRouter: AlertRouter
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    init() {
        tutorialSceneFactory = StoryboardTutorialSceneFactory()
        presentationAssets = ApplicationPresentationAssets()
        alertRouter = WindowAlertRouter.shared
        tutorialStateProviding = UserDefaultsTutorialStateProvider(userDefaults: .standard)
        networkReachability = SystemConfigurationNetworkReachability()
        witnessedTutorialPushPermissionsRequest = UserDefaultsWitnessedTutorialPushPermissionsRequest(userDefaults: .standard)
    }

    func with(_ tutorialSceneFactory: TutorialSceneFactory) -> TutorialModuleBuilder {
        self.tutorialSceneFactory = tutorialSceneFactory
        return self
    }

    func with(_ presentationAssets: PresentationAssets) -> TutorialModuleBuilder {
        self.presentationAssets = presentationAssets
        return self
    }

    func with(_ alertRouter: AlertRouter) -> TutorialModuleBuilder {
        self.alertRouter = alertRouter
        return self
    }

    func with(_ tutorialStateProviding: UserCompletedTutorialStateProviding) -> TutorialModuleBuilder {
        self.tutorialStateProviding = tutorialStateProviding
        return self
    }

    func with(_ networkReachability: NetworkReachability) -> TutorialModuleBuilder {
        self.networkReachability = networkReachability
        return self
    }

    func with(_ witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest) -> TutorialModuleBuilder {
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        return self
    }

    func build() -> TutorialModuleProviding {
        return TutorialModule(tutorialSceneFactory: tutorialSceneFactory,
                                          presentationAssets: presentationAssets,
                                          alertRouter: alertRouter,
                                          tutorialStateProviding: tutorialStateProviding,
                                          networkReachability: networkReachability,
                                          witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)
    }

}
