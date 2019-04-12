@testable import Eurofurence
import EurofurenceModel
import XCTest

class CapturingLoginSceneDelegate: LoginSceneDelegate {

    private(set) var toldLoginSceneWillAppear = false
    func loginSceneWillAppear() {
        toldLoginSceneWillAppear = true
    }

    private(set) var cancelButtonTapped = false
    func loginSceneDidTapCancelButton() {
        cancelButtonTapped = true
    }

    private(set) var loginButtonTapped = false
    func loginSceneDidTapLoginButton() {
        loginButtonTapped = true
    }

    private(set) var capturedRegistrationNumber: String?
    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String) {
        capturedRegistrationNumber = registrationNumberString
    }

    private(set) var capturedUsername: String?
    func loginSceneDidUpdateUsername(_ username: String) {
        capturedUsername = username
    }

    private(set) var capturedPassword: String?
    func loginSceneDidUpdatePassword(_ password: String) {
        capturedPassword = password
    }

}

class LoginViewControllerTests: XCTestCase {

    var loginViewController: LoginViewController!
    var delegate: CapturingLoginSceneDelegate!

    override func setUp() {
        super.setUp()

        let viewController = LoginViewControllerFactory().makeLoginScene()
        precondition(viewController is LoginViewController)
        loginViewController = viewController as? LoginViewController
        loginViewController.loadViewIfNeeded()
        delegate = CapturingLoginSceneDelegate()
        loginViewController.delegate = delegate
    }

    func testDelegateIsToldWhenSceneWillAppear() {
        loginViewController.viewWillAppear(false)
        XCTAssertTrue(delegate.toldLoginSceneWillAppear)
    }

    func testDelegateIsNotToldSceneWillAppearTooEarly() {
        XCTAssertFalse(delegate.toldLoginSceneWillAppear)
    }

    func testLoginButtonIsDisabledByDefault() {
        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }

    func testEnablingTheLoginButton() {
        loginViewController.enableLoginButton()
        XCTAssertTrue(loginViewController.loginButton.isEnabled)
    }

    func testDisablingTheLoginButton() {
        loginViewController.enableLoginButton()
        loginViewController.disableLoginButton()

        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }

    func testTappingLoginButtonTellsDelegate() {
        loginViewController.loginButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.loginButtonTapped)
    }

    func testDelegateNotToldLoginButtonTappedTooEarly() {
        XCTAssertFalse(delegate.loginButtonTapped)
    }

    func testTappingCancelButtonTellsDelegate() {
        loginViewController.cancelButtonTapped(loginViewController.cancelButton as Any)
        XCTAssertTrue(delegate.cancelButtonTapped)
    }

    func testDelegateNotToldCancelButtonTappedTooEarly() {
        XCTAssertFalse(delegate.cancelButtonTapped)
    }

    func testUpdatingRegistrationNumberTextTellsDelegate() {
        let input = String.random
        loginViewController.registrationNumberTextField.text = input
        loginViewController.registrationNumberTextField.sendActions(for: .editingChanged)

        XCTAssertEqual(input, delegate.capturedRegistrationNumber)
    }

    func testUpdatingUsernameTextTellsDelegate() {
        let input = String.random
        loginViewController.usernameTextField.text = input
        loginViewController.usernameTextField.sendActions(for: .editingChanged)

        XCTAssertEqual(input, delegate.capturedUsername)
    }

    func testUpdatingPasswordTextTellsDelegate() {
        let input = String.random
        loginViewController.passwordTextField.text = input
        loginViewController.passwordTextField.sendActions(for: .editingChanged)

        XCTAssertEqual(input, delegate.capturedPassword)
    }

    func testSettingLoginTitleUpdatesViewControllerTitle() {
        let title = String.random
        loginViewController.setLoginTitle(title)

        XCTAssertEqual(title, loginViewController.title)
    }

}
