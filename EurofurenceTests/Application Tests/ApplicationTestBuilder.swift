//
//  ApplicationTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class ApplicationTestBuilder {
    
    struct Context {
        var application: EurofurenceApplication
        
        var capturingLoginController: CapturingLoginController
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var capturingLoginCredentialsStore: CapturingLoginCredentialStore
        var jsonPoster: CapturingJSONPoster
        
        func registerRemoteNotifications(_ deviceToken: Data = Data()) {
            application.registerRemoteNotifications(deviceToken: deviceToken)
        }
        
        func login(registrationNumber: Int = 0, username: String = "", password: String = "") {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            application.login(arguments)
        }
        
        func notifyUserLoggedIn(_ token: String = "", expires: Date = .distantFuture) {
            capturingLoginController.notifyUserLoggedIn(token, expires: expires)
        }
        
        func notifyUserLoggedOut() {
            capturingLoginController.notifyUserLoggedOut()
        }
        
        func simulateJSONResponse(_ data: Data?) {
            jsonPoster.invokeLastCompletionHandler(responseData: data)
        }
    }
    
    private let capturingLoginController = CapturingLoginController()
    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingLoginCredentialsStore = CapturingLoginCredentialStore()
    private var stubClock = StubClock()
    private let jsonPoster = CapturingJSONPoster()
    
    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        stubClock = StubClock(currentDate: currentDate)
        return self
    }
    
    func with(_ persistedCredential: LoginCredential?) -> ApplicationTestBuilder {
        capturingLoginCredentialsStore = CapturingLoginCredentialStore(persistedCredential: persistedCredential)
        return self
    }
    
    func build() -> Context {
        let app = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration,
                                         loginController: capturingLoginController,
                                         clock: stubClock,
                                         loginCredentialStore: capturingLoginCredentialsStore,
                                         jsonPoster: jsonPoster)
        return Context(application: app,
                       capturingLoginController: capturingLoginController,
                       capturingTokenRegistration: capturingTokenRegistration,
                       capturingLoginCredentialsStore: capturingLoginCredentialsStore,
                       jsonPoster: jsonPoster)
    }
    
}
