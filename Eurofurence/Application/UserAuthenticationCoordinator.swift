//
//  UserAuthenticationCoordinator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class UserAuthenticationCoordinator: LoginTaskDelegate, CredentialPersisterDelegate {

    var userAuthenticationToken: String?
    var registeredDeviceToken: Data?
    private var loginAPI: LoginAPI
    private var credentialPersister: CredentialPersister
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var loginObservers = [LoginObserver]()
    private var authenticationStateObservers = [AuthenticationStateObserver]()
    private var loggedInUser: User?

    private var isLoggedIn: Bool {
        return userAuthenticationToken != nil
    }

    init(clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         loginAPI: LoginAPI) {
        self.loginAPI = loginAPI
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        credentialPersister = CredentialPersister(clock: clock, loginCredentialStore: loginCredentialStore)
        credentialPersister.loadCredential(delegate: self)
    }

    func add(_ loginObserver: LoginObserver) {
        loginObservers.append(loginObserver)
    }

    func remove(_ loginObserver: LoginObserver) {
        guard let idx = loginObservers.index(where: { $0 === loginObserver }) else { return }
        loginObservers.remove(at: idx)
    }

    func add(_ authenticationStateObserver: AuthenticationStateObserver) {
        authenticationStateObservers.append(authenticationStateObserver)

        if let loggedInUser = loggedInUser {
            authenticationStateObserver.loggedIn(as: loggedInUser)
        }
    }

    func remove(_ authenticationStateObserver: AuthenticationStateObserver) {
        guard let idx = authenticationStateObservers.index(where: { $0 === authenticationStateObserver }) else { return }
        authenticationStateObservers.remove(at: idx)
    }

    func login(_ arguments: LoginArguments) {
        if isLoggedIn {
            notifyLoginSucceeded()
        } else {
            LoginTask(delegate: self, arguments: arguments, loginAPI: loginAPI).start()
        }
    }

    // MARK: LoginTaskDelegate

    func loginTask(_ task: LoginTask, didProduce loginCredential: LoginCredential) {
        loggedInUser = User(registrationNumber: loginCredential.registrationNumber, username: loginCredential.username)
        credentialPersister.persist(loginCredential)
        notifyLoginSucceeded()
        userAuthenticationToken = loginCredential.authenticationToken

        if let registeredDeviceToken = registeredDeviceToken {
            remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                        userAuthenticationToken: userAuthenticationToken)
        }
    }

    func loginTaskDidFail(_ task: LoginTask) {
        loginObservers.forEach { $0.userDidFailToLogIn() }
    }

    // MARK: CredentialPersisterDelegate

    func credentialPersister(_ credentialPersister: CredentialPersister, didRetrieve loginCredential: LoginCredential) {
        userAuthenticationToken = loginCredential.authenticationToken
        loggedInUser = User(registrationNumber: loginCredential.registrationNumber, username: loginCredential.username)
    }

    // MARK: Private

    private func notifyLoginSucceeded() {
        loginObservers.forEach { $0.userDidLogin() }

        guard let loggedInUser = loggedInUser else { return }
        authenticationStateObservers.forEach { $0.loggedIn(as: loggedInUser) }
    }

}
