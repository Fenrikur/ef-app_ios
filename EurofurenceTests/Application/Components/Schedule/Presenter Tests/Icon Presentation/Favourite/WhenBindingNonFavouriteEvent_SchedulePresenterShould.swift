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
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
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
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionForComponent(at: indexPath)
        action?.run()

        XCTAssertTrue(eventViewModel.isFavourite, "Running the action should favourite the event")
    }

}