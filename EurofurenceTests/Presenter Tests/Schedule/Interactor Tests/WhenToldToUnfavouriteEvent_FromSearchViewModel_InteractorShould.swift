@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToUnfavouriteEvent_FromSearchViewModel_InteractorShould: XCTestCase {

    func testUnfavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let events = [FakeEvent].random
        eventsService.allEvents = events
        let randomEvent = events.randomElement()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let viewModel = context.makeSearchViewModel()
        eventsService.lastProducedSearchController?.simulateSearchResultsChanged([randomEvent.element])
        viewModel?.updateSearchResults(input: randomEvent.element.title)
        let indexPath = IndexPath(item: 0, section: 0)
        viewModel?.unfavouriteEvent(at: indexPath)

        XCTAssertEqual(randomEvent.element.favouritedState, .unfavourited)
    }

}
