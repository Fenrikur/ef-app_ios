//
//  LoginPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubLoginSceneFactory: LoginSceneFactory {
    
    let stubScene = CapturingLoginScene()
    func makeLoginScene() -> UIViewController & LoginScene {
        return stubScene
    }
    
}

class CapturingLoginScene: UIViewController, LoginScene {
    
    var delegate: LoginSceneDelegate?
    
    var loginButtonWasDisabled = false
    func disableLoginButton() {
        loginButtonWasDisabled = true
    }
    
    private(set) var loginButtonWasEnabled = false
    func enableLoginButton() {
        loginButtonWasEnabled = true
    }
    
    func tapLoginButton() {
        delegate?.loginSceneDidTapLoginButton()
    }
    
}

class CapturingLoginModuleDelegate: LoginModuleDelegate {
    
    private(set) var loginCancelled = false
    func loginModuleDidCancelLogin() {
        loginCancelled = true
    }
    
    private(set) var loginFinishedSuccessfully = false
    func loginModuleDidLoginSuccessfully() {
        loginFinishedSuccessfully = true
    }
    
}

class CapturingLoginService: LoginService {
    
    private(set) var capturedRequest: LoginServiceRequest?
    private var capturedCompletionHandler: ((LoginServiceResult) -> Void)?
    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
        capturedRequest = request
        capturedCompletionHandler = completionHandler
    }
    
    func fulfillRequest() {
        capturedCompletionHandler?(.success)
    }
    
    func failRequest() {
        capturedCompletionHandler?(.failure)
    }
    
}

class LoginPresenterTests: XCTestCase {
    
    var loginSceneFactory: StubLoginSceneFactory!
    var loginService: CapturingLoginService!
    var scene: UIViewController!
    var delegate: CapturingLoginModuleDelegate!
    var presentationStrings: StubPresentationStrings!
    var alertRouter: CapturingAlertRouter!
    
    override func setUp() {
        super.setUp()
        
        loginSceneFactory = StubLoginSceneFactory()
        loginService = CapturingLoginService()
        presentationStrings = StubPresentationStrings()
        alertRouter = CapturingAlertRouter()
        alertRouter.automaticallyPresentAlerts = true
        let moduleFactory = PhoneLoginModuleFactory(sceneFactory: loginSceneFactory,
                                                    loginService: loginService,
                                                    presentationStrings: presentationStrings,
                                                    alertRouter: alertRouter)
        delegate = CapturingLoginModuleDelegate()
        scene = moduleFactory.makeLoginModule(delegate)
    }
    
    private func inputValidCredentials() {
        updateRegistrationNumber("1")
        updateUsername("Username")
        updatePassword("Password")
    }
    
    private func updateRegistrationNumber(_ registrationNumber: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber(registrationNumber)
    }
    
    private func updateUsername(_ username: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername(username)
    }
    
    private func updatePassword(_ password: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword(password)
    }
    
    private func completeAlertPresentation() {
        alertRouter.completePendingPresentation()
    }
    
    private func simulateLoginFailure() {
        loginService.failRequest()
    }
    
    private func simulateLoginSuccess() {
        loginService.fulfillRequest()
    }
    
    private func tapLoginButton() {
        loginSceneFactory.stubScene.tapLoginButton()
    }
    
    private func dismissLastAlert() {
        alertRouter.lastAlert?.completeDismissal()
    }
    
    func testTheSceneFromTheFactoryIsReturned() {
        XCTAssertEqual(scene, loginSceneFactory.stubScene)
    }
    
    func testTappingTheCancelButtonTellsDelegateLoginCancelled() {
        loginSceneFactory.stubScene.delegate?.loginSceneDidTapCancelButton()
        XCTAssertTrue(delegate.loginCancelled)
    }
    
    func testTheDelegateIsNotToldLoginCancelledUntilUserTapsButton() {
        XCTAssertFalse(delegate.loginCancelled)
    }
    
    func testTheLoginButtonIsDisabled() {
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsTheLoginButtonIsEnabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        updatePassword("Password")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithoutRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("")
        updateUsername("User")
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("?")
        updateUsername("User")
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidUsernameTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("1")
        updateUsername("")
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidPasswordTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        updatePassword("")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidPasswordTheLoginButtonShouldBeDisabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updatePassword("")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithPasswordEnteredLastTheLoginButtonNotBeDisabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldBeDisabled() {
        updateUsername("User")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateRegistrationNumber("?")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithRegistrationNumberEnteredLastTheLoginButtonShouldNotBeDisabled() {
        updateUsername("User")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateRegistrationNumber("42")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidUsernameTheLoginButtonShouldBeDisabled() {
        updateRegistrationNumber("1")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateUsername("")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithUsernameEnteredLastTheLoginButtonShouldNotBeDisabled() {
        updateRegistrationNumber("1")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateUsername("User")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testTappingLoginButtonTellsLoginServiceToPerformLoginWithEnteredValues() {
        let regNo = 1
        let username = "User"
        let password = "Password"
        updateRegistrationNumber("\(regNo)")
        updateUsername(username)
        updatePassword(password)
        loginSceneFactory.stubScene.tapLoginButton()
        completeAlertPresentation()
        let expected = LoginServiceRequest(registrationNumber: regNo, username: username, password: password)
        
        XCTAssertEqual(expected, loginService.capturedRequest)
    }
    
    func testAlertWithLoggingInTitleDisplayedWhenLoginServiceBeginsLoginProcedure() {
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertEqual(presentationStrings[.loggingIn], alertRouter.presentedAlertTitle)
    }
    
    func testTappingLoginButtonWaitsForAlertPresentationToFinishBeforeAskingServiceToLogin() {
        alertRouter.automaticallyPresentAlerts = false
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertNil(loginService.capturedRequest)
    }
    
    func testAlertWithLogginInDescriptionDisplayedWhenLoginServiceBeginsLoginProcedure() {
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertEqual(presentationStrings[.loggingInDetail], alertRouter.presentedAlertMessage)
    }
    
    func testLoginServiceSucceedsWithLoginTellsAlertToDismiss() {
        inputValidCredentials()
        tapLoginButton()
        let alert = alertRouter.lastAlert
        simulateLoginSuccess()
        
        XCTAssertEqual(true, alert?.dismissed)
    }
    
    func testAlertNotDismissedBeforeServiceReturns() {
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertEqual(false, alertRouter.lastAlert?.dismissed)
    }
    
    func testLoginServiceFailsToLoginShowsAlertWithLoginErrorTitle() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertEqual(presentationStrings[.loginError], alertRouter.presentedAlertTitle)
    }
    
    func testLoginSucceedsDoesNotShowLoginFailedAlert() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginSuccess()
        dismissLastAlert()
        
        XCTAssertNotEqual(presentationStrings[.loginError], alertRouter.presentedAlertTitle)
    }
    
    func testLoginErrorAlertIsNotShownUntilPreviousAlertIsDismissed() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        
        XCTAssertNotEqual(presentationStrings[.loginError], alertRouter.presentedAlertTitle)
    }
    
    func testLoginServiceFailsToLoginShowsAlertWithLoginErrorDetail() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertEqual(presentationStrings[.loginErrorDetail], alertRouter.presentedAlertMessage)
    }
    
    func testLoginServiceFailsToLoginShowsAlertWithOKAction() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertNotNil(alertRouter.capturedAction(title: presentationStrings[.ok]))
    }
    
    func testLoginServiceSucceedsTellsDelegateLoginSucceeded() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginSuccess()
        dismissLastAlert()
        
        XCTAssertTrue(delegate.loginFinishedSuccessfully)
    }
    
    func testLoginServiceFailsDoesNotTellDelegateLoginSucceeded() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertFalse(delegate.loginFinishedSuccessfully)
    }
    
}
