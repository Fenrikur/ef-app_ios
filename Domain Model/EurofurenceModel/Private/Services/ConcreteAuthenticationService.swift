import EventBus
import Foundation

class ConcreteAuthenticationService: AuthenticationService {

    private let eventBus: EventBus
    private let clock: Clock
    private let credentialStore: CredentialStore
    private let api: API
    private let remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    private var userAuthenticationToken: String?
    private var registeredDeviceToken: Data?
    private var loggedInUser: User?
    private var observers = [AuthenticationStateObserver]()

    init(eventBus: EventBus,
         clock: Clock,
         credentialStore: CredentialStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?,
         api: API) {
        self.eventBus = eventBus
        self.clock = clock
        self.credentialStore = credentialStore
        self.api = api
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration

        loadPersistedCredential()
        eventBus.subscribe(remoteNotificationTokenDidChange)
    }

    func login(_ args: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        if let user = loggedInUser {
            completionHandler(.success(user))
            return
        }

        let request = LoginRequest(regNo: args.registrationNumber, username: args.username, password: args.password)
        api.performLogin(request: request) { (response) in
            if let response = response {
                self.handleLoginSuccess(args, response: response, completionHandler: completionHandler)
            } else {
                completionHandler(.failure)
            }
        }
    }

    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        remoteNotificationsTokenRegistration?.registerRemoteNotificationsDeviceToken(registeredDeviceToken,
                                                                                    userAuthenticationToken: nil) { error in
            if error != nil {
                self.observers.forEach({ $0.userDidFailToLogout() })
                completionHandler(.failure)
            } else {
                self.credentialStore.deletePersistedToken()
                self.loggedInUser = nil
                self.userAuthenticationToken = nil
                self.observers.forEach({ $0.userDidLogout() })
                self.eventBus.post(DomainEvent.LoggedOut())
                completionHandler(.success)
            }
        }
    }

    func add(_ observer: AuthenticationStateObserver) {
        observers.append(observer)

        if let user = loggedInUser {
            observer.userDidLogin(user)
        } else {
            observer.userDidLogout()
        }
    }

    // MARK: Private

    private func loadPersistedCredential() {
        if let credential = credentialStore.persistedCredential, credential.isValid(currentDate: clock.currentDate) {
            updateCurrentUser(from: credential)
        }
    }

    private func remoteNotificationTokenDidChange(_ event: DomainEvent.RemoteNotificationTokenAvailable) {
        registeredDeviceToken = event.deviceToken
    }

    private func handleLoginSuccess(_ args: LoginArguments,
                                    response: LoginResponse,
                                    completionHandler: @escaping (LoginResult) -> Void) {
        let credential = Credential(username: args.username,
                                    registrationNumber: args.registrationNumber,
                                    authenticationToken: response.token,
                                    tokenExpiryDate: response.tokenValidUntil)
        credentialStore.store(credential)
        updateCurrentUser(from: credential)
        
        if let loggedInUser = loggedInUser {
            completionHandler(.success(loggedInUser))
        }
    }

    private func updateCurrentUser(from credential: Credential) {
        userAuthenticationToken = credential.authenticationToken
        let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
        loggedInUser = user
        eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))
        observers.forEach({ $0.userDidLogin(user) })
    }

}