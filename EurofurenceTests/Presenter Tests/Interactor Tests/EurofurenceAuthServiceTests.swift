//
//  EurofurenceAuthServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol EurofurenceApplicationProtocol {
    
    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void)
    
}

class EurofurenceAuthService: AuthService {
    
    private let app: EurofurenceApplicationProtocol
    
    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }
    
    func add(observer: AuthStateObserver) {
        
    }
    
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        app.retrieveCurrentUser { _ in completionHandler(.loggedOut) }
    }
    
}

class CapturingEurofurenceApplication: EurofurenceApplicationProtocol {
    
    private(set) var wasRequestedForCurrentUser = false
    private var retrieveUserCompletionHandler: ((User?) -> Void)?
    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        wasRequestedForCurrentUser = true
        retrieveUserCompletionHandler = completionHandler
    }
    
    func resolveUserRetrievalWithUser(_ user: User?) {
        retrieveUserCompletionHandler?(user)
    }
    
}

class CapturingAuthStateHandler {
    
    private(set) var capturedState: AuthState?
    func handle(_ state: AuthState) {
        capturedState = state
    }
    
}

class EurofurenceAuthServiceTests: XCTestCase {
    
    var app: CapturingEurofurenceApplication!
    var service: EurofurenceAuthService!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        service = EurofurenceAuthService(app: app)
    }
    
    func testDeterminingAuthStateRequestsUserFromApplication() {
        service.determineAuthState { _ in }
        XCTAssertTrue(app.wasRequestedForCurrentUser)
    }
    
    func testWhenNilUserReturnedTheAuthStateIsResolvedAsLoggedOut() {
        let handler = CapturingAuthStateHandler()
        service.determineAuthState(completionHandler: handler.handle)
        app.resolveUserRetrievalWithUser(nil)
        
        XCTAssertEqual(.loggedOut, handler.capturedState)
    }
    
}
