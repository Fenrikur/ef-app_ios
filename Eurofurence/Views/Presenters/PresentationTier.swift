//
//  PresentationTier.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class PresentationTier {

    class func assemble(window: UIWindow) -> PresentationTier {
        return PresentationTier(window: window)
    }

    private var routers: StoryboardRouters
    private var root: BootstrappingPresenter?
    private var finishedTutorialProvider: UserDefaultsTutorialStateProvider

    private init(window: UIWindow) {
        self.routers = StoryboardRouters(window: window)
        self.finishedTutorialProvider = UserDefaultsTutorialStateProvider(userDefaults: .standard)
        let appContext = ApplicationContext(firstTimeLaunchProviding: finishedTutorialProvider, tutorialItems: makeTutorialItems())

        root = BootstrappingPresenter(context: appContext, routers: routers)
    }

    private func makeTutorialItems() -> [TutorialPageInfo] {
        func temporaryWorkaroundIntoAppUntilTutorialIsFinished() {
            finishedTutorialProvider.markTutorialAsComplete()
            routers.splashScreenRouter.showSplashScreen()
        }

        let action = TutorialBlockAction(block: temporaryWorkaroundIntoAppUntilTutorialIsFinished)
        let beginDownloadAction = TutorialPageAction(actionDescription: "Let's Go",
                                                     action: action)
        let beginDownloadItem = TutorialPageInfo(image: nil,
                                                 title: "Hello!",
                                                 description: "This is a work in progress, hit the button below to skip this for now.",
                                                 primaryAction: beginDownloadAction)

        return [beginDownloadItem]
    }

}
