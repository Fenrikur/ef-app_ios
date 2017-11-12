//
//  PhoneMessagesModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct PhoneMessagesModuleFactory: MessagesModuleFactory {

    private let sceneFactory: MessagesSceneFactory
    private let authService: AuthService
    private let privateMessagesService: PrivateMessagesService
    private let dateFormatter: DateFormatterProtocol

    init(sceneFactory: MessagesSceneFactory,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         dateFormatter: DateFormatterProtocol) {
        self.sceneFactory = sceneFactory
        self.authService = authService
        self.privateMessagesService = privateMessagesService
        self.dateFormatter = dateFormatter
    }

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMessagesScene()
        _ = MessagesPresenter(scene: scene,
                              authService: authService,
                              privateMessagesService: privateMessagesService,
                              dateFormatter: dateFormatter,
                              delegate: delegate)

        return scene
    }

}
