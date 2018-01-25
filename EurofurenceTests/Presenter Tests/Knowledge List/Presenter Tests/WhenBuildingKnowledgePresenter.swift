//
//  WhenBuildingKnowledgePresenter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenBuildingKnowledgePresenter: XCTestCase {
    
    func testItShouldNotTellInteractorToPrepareViewModel() {
        let context = KnowledgeListPresenterTestBuilder().build()
        XCTAssertFalse(context.knowledgeInteractor.toldToPrepareViewModel)
    }
    
    func testItShouldNotTellTheSceneToShowTheLoadingIndicator() {
        let context = KnowledgeListPresenterTestBuilder().build()
        XCTAssertFalse(context.scene.didShowLoadingIndicator)
    }
    
}
