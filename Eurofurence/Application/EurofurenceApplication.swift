//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EurofurenceApplication {

    static var shared: EurofurenceApplication = {
        let JSONSession = URLSessionBasedJSONSession()
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: JSONSession)
        let tokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                             appVersion: BundleAppVersionProviding(),
                                                                             firebaseAdapter: FirebaseMessagingAdapter(),
                                                                             fcmRegistration: fcmRegistration)

        return EurofurenceApplication(remoteNotificationsTokenRegistration: tokenRegistration,
                                      clock: SystemClock(),
                                      loginCredentialStore: KeychainLoginCredentialStore(),
                                      loginAPI: V2LoginAPI(JSONSession: JSONSession),
                                      privateMessagesAPI: V2PrivateMessagesAPI(JSONSession: JSONSession))
    }()

    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var authenticationCoordinator: UserAuthenticationCoordinator
    private var registeredDeviceToken: Data?
    private var privateMessagesObservers = [PrivateMessagesObserver]()
    private let privateMessagesAPI: PrivateMessagesAPI

    init(remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration,
         clock: Clock,
         loginCredentialStore: LoginCredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        self.privateMessagesAPI = privateMessagesAPI

        authenticationCoordinator = UserAuthenticationCoordinator(clock: clock,
                                                                  loginCredentialStore: loginCredentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)
    }

    func add(loginObserver: LoginObserver) {
        authenticationCoordinator.add(loginObserver)
    }

    func remove(loginObserver: LoginObserver) {
        authenticationCoordinator.remove(loginObserver)
    }

    func add(logoutObserver: LogoutObserver) {
        authenticationCoordinator.add(logoutObserver)
    }

    func add(authenticationStateObserver: AuthenticationStateObserver) {
        authenticationCoordinator.add(authenticationStateObserver)
    }

    func remove(authenticationStateObserver: AuthenticationStateObserver) {
        authenticationCoordinator.remove(authenticationStateObserver)
    }

    func add(privateMessagesObserver: PrivateMessagesObserver) {
        privateMessagesObservers.append(privateMessagesObserver)
    }

    func login(_ arguments: LoginArguments) {
        authenticationCoordinator.login(arguments)
    }

    func logout() {
        authenticationCoordinator.logout()
    }

    func registerForRemoteNotifications(deviceToken: Data) {
        registeredDeviceToken = deviceToken
        authenticationCoordinator.registeredDeviceToken = deviceToken
        remoteNotificationsTokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                                    userAuthenticationToken: authenticationCoordinator.userAuthenticationToken) { _ in }
    }

    func fetchPrivateMessages() {
        if let token = authenticationCoordinator.userAuthenticationToken {
            privateMessagesAPI.loadPrivateMessages(authorizationToken: token) { response in
                switch response {
                case .success(let response):
                    let messages = response.messages.map(self.makeMessage)
                    self.privateMessagesObservers.forEach({ $0.privateMessagesAvailable(messages) })

                case .failure:
                    self.privateMessagesObservers.forEach({ $0.failedToLoadPrivateMessages() })
                }
            }
        } else {
            privateMessagesObservers.forEach({ $0.userNotAuthenticatedForPrivateMessages() })
        }
    }

    func markMessageAsRead(_ message: Message) {
        guard let token = authenticationCoordinator.userAuthenticationToken else { return }

        privateMessagesAPI.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
    }

    private func makeMessage(from apiMessage: APIPrivateMessage) -> Message {
        return Message(identifier: apiMessage.id,
                       authorName: apiMessage.authorName,
                       receivedDateTime: apiMessage.receivedDateTime,
                       subject: apiMessage.subject,
                       contents: apiMessage.message,
                       isRead: apiMessage.readDateTime != nil)
    }

}
