//
//  WhenBindingNonFavouriteEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingNonFavouriteEvent_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToHideTheFavouriteEventIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.favouriteIconVisibility, .hidden)
    }

    func testSupplyFavouriteActionInformation() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionForComponent(at: indexPath)

        XCTAssertEqual(.favourite, action?.title)
    }

    func testTellViewModelToFavouriteEventAtIndexPathWhenInvokingAction() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionForComponent(at: indexPath)
        action?.run()

        XCTAssertEqual(indexPath, viewModel.indexPathForFavouritedEvent)
    }

}
