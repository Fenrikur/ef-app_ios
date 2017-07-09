//
//  StoryboardRouters.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardRouters: Routers {

    init(window: UIWindow) {
        tutorialRouter = StoryboardTutorialRouter(window: window)
        splashScreenRouter = StoryboardSplashScreenRouter(window: window)
    }

    var tutorialRouter: TutorialRouter
    var splashScreenRouter: SplashScreenRouter

}
