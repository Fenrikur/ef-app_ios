//
//  NewsPresenterTestsForAnonymousUser.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class NewsPresenterTestsForAnonymousUser: XCTestCase {
    
    // MARK: When Scene Will Appear
    
    func testTheSceneIsToldToShowTheLoginNavigationAction() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertTrue(context.newsScene.wasToldToShowLoginNavigationAction)
    }
    
    func testTheSceneIsToldToHideTheMessagesNavigationAction() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertTrue(context.newsScene.wasToldToHideMessagesNavigationAction)
    }
    
    func testTheNewsSceneIsToldToShowWelcomePrompt() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertEqual(context.newsScene.capturedLoginPrompt, .anonymousUserLoginPrompt)
    }
    
    func testTheNewsSceneIsToldToShowWelcomeDescription() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        
        XCTAssertEqual(context.newsScene.capturedLoginDescription, .anonymousUserLoginDescription)
    }
    
    // MARK: When Logging In
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldShowTheMessagesNavigationAction() {
        let context = NewsPresenterTestBuilder().build()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToShowMessagesNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheSceneShouldHideTheLoginNavigationAction() {
        let context = NewsPresenterTestBuilder().build()
        context.authService.notifyObserversUserDidLogin()
        
        XCTAssertTrue(context.newsScene.wasToldToHideLoginNavigationAction)
    }
    
    func testWhenAuthServiceIndicatesUserLoggedInTheWelcomePromptShouldBeSourcedUsingTheUser() {
        let context = NewsPresenterTestBuilder().build()
        let user = User(registrationNumber: 42, username: "Test")
        context.authService.notifyObserversUserDidLogin(user)
        
        XCTAssertEqual(context.newsScene.capturedWelcomePrompt, .welcomePrompt(for: user))
    }
    
    // MARK: When Tapping Login Action
    
    func testWhenTheLoginActionIsTappedThePerformLoginCommandIsRan() {
        let context = NewsPresenterTestBuilder().build()
        context.newsScene.tapLoginAction()
        
        XCTAssertTrue(context.delegate.loginRequested)
    }
    
}
