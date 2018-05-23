//
//  WhenPreparingViewModel_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEventDetailViewModelVisitor: EventDetailViewModelVisitor {
    
    private(set) var visitedViewModels = [AnyHashable]()
    
    private(set) var visitedEventSummary: EventSummaryViewModel?
    func visit(_ summary: EventSummaryViewModel) {
        visitedViewModels.append(summary)
    }
    
    func visit(_ description: EventDescriptionViewModel) {
        visitedViewModels.append(description)
    }
    
    func visit(_ graphic: EventGraphicViewModel) {
        visitedViewModels.append(graphic)
    }
    
}

class WhenPreparingViewModel_EventDetailInteractorShould: XCTestCase {
    
    var context: EventDetailInteractorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventDetailInteractorTestBuilder().build()
    }
    
    func testProduceViewModelWithExpectedNumberOfComponents() {
        XCTAssertEqual(2, context.viewModel?.numberOfComponents)
    }
    
    func testProduceExpectedSummaryViewModelAtIndexZero() {
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 0, to: visitor)
        
        XCTAssertEqual([context.makeExpectedEventSummaryViewModel()], visitor.visitedViewModels)
    }
    
    func testProduceExpectedDescriptionViewModelAtIndexOne() {
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 1, to: visitor)
        
        XCTAssertEqual([context.makeExpectedEventDescriptionViewModel()], visitor.visitedViewModels)
    }
    
}
