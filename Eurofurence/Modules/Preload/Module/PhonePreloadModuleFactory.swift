//
//  PhonePreloadModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct PhonePreloadModuleFactory: PreloadModuleProviding {

    var preloadSceneFactory: PreloadSceneFactory
    var preloadService: PreloadInteractor
    var alertRouter: AlertRouter

    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(delegate: delegate,
                             preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter)

        return preloadScene
    }

}
