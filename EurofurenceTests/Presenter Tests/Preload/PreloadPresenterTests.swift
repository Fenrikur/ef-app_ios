//
//  PreloadPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PreloadPresenterTests: XCTestCase {
    
    class PreloadPresenterTestContext {
        
        var preloadViewController: UIViewController?
        let preloadSceneFactory = StubPreloadSceneFactory()
        let capturingQuoteGenerator = CapturingQuoteGenerator()
        let preloadingService = CapturingPreloadService()
        let alertRouter = CapturingAlertRouter()
        let delegate = CapturingPreloadModuleDelegate()
        
        func with(_ quote: Quote) -> PreloadPresenterTestContext {
            capturingQuoteGenerator.quoteToMake = quote
            return self
        }
        
        func build() -> PreloadPresenterTestContext {
            preloadViewController = PreloadModuleBuilder()
                .with(preloadSceneFactory)
                .with(preloadingService)
                .with(alertRouter)
                .with(capturingQuoteGenerator)
                .build()
                .makePreloadModule(delegate)
            
            return self
        }
        
    }
    
    func testThePreloadControllerIsReturnedFromTheFactory() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertEqual(context.preloadViewController, context.preloadSceneFactory.splashScene)
    }
    
    func testTheQuotesDataSourceIsToldToMakeQuote() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertTrue(context.capturingQuoteGenerator.toldToMakeQuote)
    }
    
    func testTheQuoteFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "", message: "Life is short, eat dessert first")
        let context = PreloadPresenterTestContext().with(someQuote).build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        
        XCTAssertEqual(someQuote.message, context.preloadSceneFactory.splashScene.shownQuote)
    }
    
    func testTheQuoteFromTheGeneratorIsNotSetOntoTheSplashSceneBeforeTheViewWillAppear() {
        let someQuote = Quote(author: "", message: "Life is short, eat dessert first")
        let context = PreloadPresenterTestContext().with(someQuote).build()
        
        XCTAssertNotEqual(someQuote.message, context.preloadSceneFactory.splashScene.shownQuote)
    }
    
    func testTheQuoteAuthorFromTheGeneratorIsSetOntoTheSplashScene() {
        let someQuote = Quote(author: "A wise man", message: "Life is short, eat dessert first")
        let context = PreloadPresenterTestContext().with(someQuote).build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()

        XCTAssertEqual(someQuote.author, context.preloadSceneFactory.splashScene.shownQuoteAuthor)
    }
    
    func testTheQuoteAuthorFromTheGeneratorIsNotSetOntoTheSplashSceneBeforeTheViewWillAppear() {
        let someQuote = Quote(author: "A wise man", message: "Life is short, eat dessert first")
        let context = PreloadPresenterTestContext().with(someQuote).build()
        
        XCTAssertNotEqual(someQuote.author, context.preloadSceneFactory.splashScene.shownQuoteAuthor)
    }
    
    func testTellTheLoadingServiceToBeginLoadingWhenSceneIsAboutToAppear() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        
        XCTAssertTrue(context.preloadingService.didBeginPreloading)
    }
    
    func testWaitUntilTheSceneIsAboutToAppearBeforeBeginningPreloading() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertFalse(context.preloadingService.didBeginPreloading)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithDownloadErrorTitle() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(.downloadError,
                       context.alertRouter.presentedAlertTitle)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithFailedToPreloadDescription() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(.preloadFailureMessage,
                       context.alertRouter.presentedAlertMessage)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithTryAgainAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.alertRouter.presentedActions.first?.title, .tryAgain)
    }
    
    func testWhenThePreloadServiceFailsTheAlertRouterIsToldToShowAlertWithCancelAction() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertEqual(context.alertRouter.presentedActions.last?.title, .cancel)
    }
    
    func testWhenThePreloadServiceSucceedsTheAlertRouterIsNotToldToShowAlert() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifySucceededPreload()
        
        XCTAssertFalse(context.alertRouter.didShowAlert)
    }
    
    func testWhenThePreloadServiceFailsThenTheCancelActionIsInvokedTheDelegateIsToldPreloadingCancelled() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        context.alertRouter.capturedAction(title: .cancel)?.invoke()
        
        XCTAssertTrue(context.delegate.notifiedPreloadCancelled)
    }
    
    func testWhenThePreloadServiceFailsTheDelegateIsNotToldPreloadCancelledUntilCancelActionInvoked() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        
        XCTAssertFalse(context.delegate.notifiedPreloadCancelled)
    }
    
    func testWhenThePreloadServiceFailsThenTheTryAgainActionIsInvokedThePreloadServiceIsToldToLoadAgain() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifyFailedToPreload()
        context.alertRouter.capturedAction(title: .tryAgain)?.invoke()
        
        XCTAssertEqual(2, context.preloadingService.beginPreloadInvocationCount)
    }
    
    func testWhenThePreloadServiceCompletesTheDelegateIsToldPreloadingFinished() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        context.preloadingService.notifySucceededPreload()
        
        XCTAssertTrue(context.delegate.notifiedPreloadFinished)
    }
    
    func testTheDelegateIsNotToldPreloadFinishedUntilTheServiceTellsUsSo() {
        let context = PreloadPresenterTestContext().build()
        XCTAssertFalse(context.delegate.notifiedPreloadFinished)
    }
    
    func testWhenThePreloadServiceProgressesTheSceneIsToldToUpdateWithTheCurrentAndTotalUnitCount() {
        let context = PreloadPresenterTestContext().build()
        context.preloadSceneFactory.splashScene.notifySceneWillAppear()
        let current = Random.makeRandomNumber(upperLimit: 100)
        let total = Random.makeRandomNumber(upperLimit: 100 - current) + current
        let expected = Float(current) / Float(total)
        context.preloadingService.notifyProgressMade(current: current, total: total)
        
        XCTAssertEqual(expected, context.preloadSceneFactory.splashScene.capturedProgress)
    }
    
}
