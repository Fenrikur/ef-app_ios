import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForDealersDenEvent_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceDealersDenHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isDealersDen = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventDealersDenMessageViewModel(message: "Dealers Den")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventDealersDenMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventDealersDenMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
