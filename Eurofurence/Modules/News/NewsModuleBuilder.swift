//
//  NewsModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class NewsModuleBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private var authenticationService: AuthenticationService
    private var privateMessagesService: PrivateMessagesService

    init() {
        newsSceneFactory = PhoneNewsSceneFactory()
        authenticationService = ApplicationAuthenticationService.shared
        privateMessagesService = EurofurencePrivateMessagesService.shared
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> NewsModuleBuilder {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func with(_ authenticationService: AuthenticationService) -> NewsModuleBuilder {
        self.authenticationService = authenticationService
        return self
    }

    func with(_ privateMessagesService: PrivateMessagesService) -> NewsModuleBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    func build() -> NewsModuleProviding {
        return PhoneNewsModuleFactory(newsSceneFactory: newsSceneFactory,
                                      authenticationService: authenticationService,
                                      privateMessagesService: privateMessagesService)
    }

}
