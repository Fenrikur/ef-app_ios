//
//  WhenSceneTapsMapDetail_ThatRepresentsDealer_MapsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapDetail_ThatRepresentsDealer_MapsPresenterShould: XCTestCase {

    func testTellTheModuleDelegateToShowDealer() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let dealerIdentifier = DealerIdentifier.random
        interactor.viewModel.resolvePositionalContent(with: dealerIdentifier)

        XCTAssertEqual(dealerIdentifier, context.delegate.capturedDealerToShow)
    }

}
