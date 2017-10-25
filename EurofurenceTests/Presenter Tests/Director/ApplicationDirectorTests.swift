//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationDirector: RootModuleDelegate,
                           TutorialModuleDelegate,
                           PreloadModuleDelegate,
                           NewsModuleDelegate {
    
    private let windowWireframe: WindowWireframe
    private let rootModuleFactory: RootModuleFactory
    private let tutorialModuleFactory: TutorialModuleFactory
    private let preloadModuleFactory: PreloadModuleFactory
    private let tabModuleFactory: TabModuleFactory
    private let newsModuleFactory: NewsModuleFactory
    private let messagesModuleFactory: MessagesModuleFactory
    private let newsNavigationController: UINavigationController

    init(windowWireframe: WindowWireframe,
         navigationControllerFactory: NavigationControllerFactory,
         rootModuleFactory: RootModuleFactory,
         tutorialModuleFactory: TutorialModuleFactory,
         preloadModuleFactory: PreloadModuleFactory,
         tabModuleFactory: TabModuleFactory,
         newsModuleFactory: NewsModuleFactory,
         messagesModuleFactory: MessagesModuleFactory) {
        self.windowWireframe = windowWireframe
        self.rootModuleFactory = rootModuleFactory
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        self.tabModuleFactory = tabModuleFactory
        self.newsModuleFactory = newsModuleFactory
        self.messagesModuleFactory = messagesModuleFactory
        
        newsNavigationController = navigationControllerFactory.makeNavigationController()
        
        rootModuleFactory.makeRootModule(self)
    }
    
    // MARK: RootModuleDelegate
    
    func userNeedsToWitnessTutorial() {
        showTutorial()
    }
    
    func storeShouldBePreloaded() {
        showPreloadModule()
    }
    
    // MARK: TutorialModuleDelegate
    
    func tutorialModuleDidFinishPresentingTutorial() {
        showPreloadModule()
    }
    
    // MARK: PreloadModuleDelegate
    
    func preloadModuleDidCancelPreloading() {
        showTutorial()
    }
    
    func preloadModuleDidFinishPreloading() {
        newsNavigationController.setViewControllers([newsModuleFactory.makeNewsModule(self)], animated: false)
        let tabModule = tabModuleFactory.makeTabModule([newsNavigationController])
        
        windowWireframe.setRoot(tabModule)
    }
    
    // MARK: NewsModuleDelegate
    
    func newsModuleDidRequestLogin() {
        newsNavigationController.pushViewController(messagesModuleFactory.makeMessagesModule(), animated: true)
    }
    
    func newsModuleDidRequestShowingPrivateMessages() {
        
    }
    
    // MARK: Private
    
    private func showPreloadModule() {
        windowWireframe.setRoot(preloadModuleFactory.makePreloadModule(self))
    }
    
    private func showTutorial() {
        windowWireframe.setRoot(tutorialModuleFactory.makeTutorialModule(self))
    }
    
}

protocol NavigationControllerFactory {
    
    func makeNavigationController() -> UINavigationController
    
}

class CapturingNavigationController: UINavigationController {
    
    private(set) var pushedViewControllers = [UIViewController]()
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
}

struct StubNavigationControllerFactory: NavigationControllerFactory {
    
    func makeNavigationController() -> UINavigationController {
        return CapturingNavigationController()
    }
    
}

protocol WindowWireframe {
    
    func setRoot(_ viewController: UIViewController)
    
}

class StubRootModuleFactory: RootModuleFactory {
    
    private(set) var delegate: RootModuleDelegate?
    func makeRootModule(_ delegate: RootModuleDelegate) {
        self.delegate = delegate
    }
    
}

class StubTutorialModuleFactory: TutorialModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: TutorialModuleDelegate?
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubPreloadModuleFactory: PreloadModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: PreloadModuleDelegate?
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubNewsModuleFactory: NewsModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var delegate: NewsModuleDelegate?
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

class StubMessagesModuleFactory: MessagesModuleFactory {
    
    let stubInterface = UIViewController()
    func makeMessagesModule() -> UIViewController {
        return stubInterface
    }
    
}

class StubTabModuleFactory: TabModuleFactory {
    
    let stubInterface = UIViewController()
    private(set) var capturedTabModules: [UIViewController] = []
    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController {
        capturedTabModules = childModules
        return stubInterface
    }
    
    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return capturedTabModules
                .flatMap({ $0 as? CapturingNavigationController })
                .first(where: { $0.topViewController === viewController })
    }
    
}

class CapturingWindowWireframe: WindowWireframe {
    
    private(set) var capturedRootInterface: UIViewController?
    func setRoot(_ viewController: UIViewController) {
        capturedRootInterface = viewController
    }
    
}

class ApplicationDirectorTests: XCTestCase {
    
    var director: ApplicationDirector!
    var rootModuleFactory: StubRootModuleFactory!
    var tutorialModuleFactory: StubTutorialModuleFactory!
    var preloadModuleFactory: StubPreloadModuleFactory!
    var tabModuleFactory: StubTabModuleFactory!
    var newsModuleFactory: StubNewsModuleFactory!
    var messagesModuleFactory: StubMessagesModuleFactory!
    var windowWireframe: CapturingWindowWireframe!
    
    override func setUp() {
        super.setUp()
        
        rootModuleFactory = StubRootModuleFactory()
        tutorialModuleFactory = StubTutorialModuleFactory()
        preloadModuleFactory = StubPreloadModuleFactory()
        windowWireframe = CapturingWindowWireframe()
        tabModuleFactory = StubTabModuleFactory()
        newsModuleFactory = StubNewsModuleFactory()
        messagesModuleFactory = StubMessagesModuleFactory()
        director = ApplicationDirector(windowWireframe: windowWireframe,
                                       navigationControllerFactory: StubNavigationControllerFactory(),
                                       rootModuleFactory: rootModuleFactory,
                                       tutorialModuleFactory: tutorialModuleFactory,
                                       preloadModuleFactory: preloadModuleFactory,
                                       tabModuleFactory: tabModuleFactory,
                                       newsModuleFactory: newsModuleFactory,
                                       messagesModuleFactory: messagesModuleFactory)
    }
    
    func testWhenRootModuleIndicatesUserNeedsToWitnessTutorialTheTutorialModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenRootModuleIndicatesStoreShouldPreloadThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenTheTutorialFinishesThePreloadModuleIsSetAsRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        
        XCTAssertEqual(preloadModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenPreloadingFailsAfterFinishingTutorialTheTutorialIsRedisplayed() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidCancelPreloading()
        
        XCTAssertEqual(tutorialModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenPreloadingSucceedsAfterFinishingTutorialTheTabWireframeIsSetAsTheRoot() {
        rootModuleFactory.delegate?.userNeedsToWitnessTutorial()
        tutorialModuleFactory.delegate?.tutorialModuleDidFinishPresentingTutorial()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        
        XCTAssertEqual(tabModuleFactory.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testWhenShowingTheTheTabModuleItIsInitialisedWithControllersForTabModulesNestedInNavigationControllers() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        
        let expected: [UIViewController] = [newsModuleFactory.stubInterface]
        let actual = tabModuleFactory.capturedTabModules.flatMap({ $0 as? UINavigationController }).flatMap({ $0.topViewController })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testWhenTheNewsModuleRequestsLoginTheMessagesControllerIsPushedOntoItsNavigationController() {
        rootModuleFactory.delegate?.storeShouldBePreloaded()
        preloadModuleFactory.delegate?.preloadModuleDidFinishPreloading()
        let newsNavigationController = tabModuleFactory.navigationController(for: newsModuleFactory.stubInterface)
        newsModuleFactory.delegate?.newsModuleDidRequestLogin()
        
        XCTAssertEqual(messagesModuleFactory.stubInterface, newsNavigationController?.pushedViewControllers.last)
    }
    
}
