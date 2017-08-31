//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct NewsPresenter: AuthStateObserver, NewsSceneDelegate {

    private let newsScene: NewsScene
    private let welcomePromptStringFactory: WelcomePromptStringFactory
    private let privateMessagesService: PrivateMessagesService
    private let performLoginCommand: Command
    private let showMessagesCommand: Command

    init(newsScene: NewsScene,
         authService: AuthService,
         privateMessagesService: PrivateMessagesService,
         welcomePromptStringFactory: WelcomePromptStringFactory,
         performLoginCommand: Command,
         showMessagesCommand: Command) {
        self.newsScene = newsScene
        self.welcomePromptStringFactory = welcomePromptStringFactory
        self.privateMessagesService = privateMessagesService
        self.performLoginCommand = performLoginCommand
        self.showMessagesCommand = showMessagesCommand

        newsScene.delegate = self

        authService.determineAuthState(completionHandler: authStateResolved)
        authService.add(observer: self)
    }

    func userDidLogin(_ user: User) {
        newsScene.showMessagesNavigationAction()
        newsScene.hideLoginNavigationAction()
        newsScene.showWelcomePrompt(welcomePromptStringFactory.makeString(for: user))

        let unreadMessageCount = privateMessagesService.unreadMessageCount
        let unreadMessagesDescription = welcomePromptStringFactory.makeDescriptionForUnreadMessages(unreadMessageCount)
        newsScene.showWelcomeDescription(unreadMessagesDescription)
    }

    func userDidLogout() {
        newsScene.showLoginNavigationAction()
        newsScene.hideMessagesNavigationAction()
        newsScene.showLoginPrompt(welcomePromptStringFactory.makeStringForAnonymousUser())
        newsScene.showLoginDescription(welcomePromptStringFactory.makeDescriptionForAnonymousUser())
    }

    func newsSceneDidTapLoginAction(_ scene: NewsScene) {
        performLoginCommand.run()
    }

    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene) {
        showMessagesCommand.run()
    }

    private func authStateResolved(_ state: AuthState) {
        switch state {
        case .loggedIn(let user):
            userDidLogin(user)

        case .loggedOut:
            userDidLogout()
        }
    }

}
