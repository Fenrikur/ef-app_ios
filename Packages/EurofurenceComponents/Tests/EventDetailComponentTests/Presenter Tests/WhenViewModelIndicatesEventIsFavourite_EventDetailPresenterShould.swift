import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenViewModelIndicatesEventIsFavourite_EventDetailPresenterShould: XCTestCase {

    func testPlaySelectionChangedHaptic() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.simulateFavourited()

        XCTAssertTrue(context.hapticEngine.played)
    }

}
