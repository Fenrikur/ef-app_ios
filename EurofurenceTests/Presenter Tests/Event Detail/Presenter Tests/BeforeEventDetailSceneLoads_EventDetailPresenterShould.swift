@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class BeforeEventDetailSceneLoads_EventDetailPresenterShould: XCTestCase {

    func testNotApplyTheEventTitleFromTheViewModel() {
        let event = FakeEvent.random
        let summary = EventSummaryViewModel.random
        let index = Int.random
        let viewModel = StubEventSummaryViewModel(summary: summary, at: index)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)

        XCTAssertNil(context.scene.stubbedEventSummaryComponent.capturedTitle)
    }

    func testNotTellTheSceneToShowTheUnfavouriteEventButton() {
        let context = EventDetailPresenterTestBuilder().build()
        XCTAssertFalse(context.scene.didShowUnfavouriteEventButton)
    }

    func testNotTellTheSceneToShowTheFavouriteEventButton() {
        let context = EventDetailPresenterTestBuilder().build()
        XCTAssertFalse(context.scene.didShowFavouriteEventButton)
    }

}
