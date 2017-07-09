//
//  BootstrappingPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class BootstrappingPresenterTests: XCTestCase {
    
    func testWhenTheAppHasNotRunBeforeTheTutorialRouterIsToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   routers: routers)

        XCTAssertTrue(tutorialRouter.wasToldToShowTutorial)
    }

    func testWhenTheAppHasRunBeforeTheSplashScreenRouterIsToldToShowTheSplashScreen() {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashScreenRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   routers: routers)

        XCTAssertTrue(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testWhenTheAppHasNotRunBeforeTheTheSplashScreenRouterShouldNotBeToldToShowTheSplashScree () {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashScreenRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   routers: routers)

        XCTAssertFalse(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testWhenTheAppHasRunBeforeTheTutorialRouterShouldNotBeToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   routers: routers)

        XCTAssertFalse(tutorialRouter.wasToldToShowTutorial)
    }
    
}
