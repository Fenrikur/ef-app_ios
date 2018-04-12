//
//  NewsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct NewsPresenter: AuthenticationStateObserver, PrivateMessagesServiceObserver, NewsSceneDelegate {

    // MARK: Nested Types

    private class DetermineAuthStateOnce {

        private var ran = false
        private let authenticationService: AuthenticationService

        init(authenticationService: AuthenticationService) {
            self.authenticationService = authenticationService
        }

        func run(_ handler: @escaping (AuthState) -> Void) {
            guard !ran else { return }

            ran = true
            authenticationService.determineAuthState(completionHandler: handler)
        }

    }

    // MARK: Properties

    private let authenticationService: AuthenticationService
    private let delegate: NewsModuleDelegate
    private let newsScene: NewsScene
    private let privateMessagesService: PrivateMessagesService
    private let determineAuthStateOnce: DetermineAuthStateOnce

    // MARK: Initialization

    init(delegate: NewsModuleDelegate,
         newsScene: NewsScene,
         newsInteractor: NewsInteractor,
         authenticationService: AuthenticationService,
         privateMessagesService: PrivateMessagesService) {
        self.delegate = delegate
        self.newsScene = newsScene
        self.authenticationService = authenticationService
        self.privateMessagesService = privateMessagesService

        determineAuthStateOnce = DetermineAuthStateOnce(authenticationService: authenticationService)

        newsScene.delegate = self
        authenticationService.add(observer: self)
        newsScene.showNewsTitle(.news)

        newsInteractor.prepareViewModel { (viewModel) in
            newsScene.bind(numberOfComponents: viewModel.components.count)
        }
    }

    // MARK: AuthStateObserver

    func userDidLogin(_ user: User) {
        newsScene.showMessagesNavigationAction()
        newsScene.hideLoginNavigationAction()
        newsScene.showWelcomePrompt(.welcomePrompt(for: user))
        newsScene.showWelcomeDescription("")
    }

    func userDidLogout() {
        newsScene.showLoginNavigationAction()
        newsScene.hideMessagesNavigationAction()
        newsScene.showLoginPrompt(.anonymousUserLoginPrompt)
        newsScene.showLoginDescription(.anonymousUserLoginDescription)
    }

    // MARK: PrivateMessageUnreadCountObserver

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        newsScene.showWelcomeDescription(.welcomeDescription(messageCount: unreadCount))
    }

    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message]) {

    }

    func privateMessagesServiceDidFailToLoadMessages() {

    }

    // MARK: NewsSceneDelegate

    func newsSceneWillAppear() {
        determineAuthStateOnce.run(authStateResolved)
        privateMessagesService.add(self)
    }

    func newsSceneDidTapLoginAction(_ scene: NewsScene) {
        delegate.newsModuleDidRequestLogin()
    }

    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene) {
        delegate.newsModuleDidRequestShowingPrivateMessages()
    }

    // MARK: Private

    private func authStateResolved(_ state: AuthState) {
        switch state {
        case .loggedIn(let user):
            userDidLogin(user)

        case .loggedOut:
            userDidLogout()
        }
    }

}
