@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFavouritingEvent_EventViewModelShould: XCTestCase {

    func testFavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        eventsService.allEvents = [event]
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        eventViewModel?.favourite()
        
        XCTAssertEqual(.favourited, event.favouritedState)
    }

}
