@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingEventSummary_EventDetailPresenterShould: XCTestCase {

    var context: EventDetailPresenterTestBuilder.Context!
    var summary: EventSummaryViewModel!
    var index: Int!
    var viewModel: StubEventSummaryViewModel!
    var boundComponent: Any?

    override func setUp() {
        super.setUp()

        let event = FakeEvent.random
        summary = .random
        index = .random
        viewModel = StubEventSummaryViewModel(summary: summary, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
    }

    func testTellTheSceneToBindTheExpectedNumberOfComponents() {
        XCTAssertEqual(viewModel.numberOfComponents, context.scene.numberOfBoundsComponents)
    }

    func testApplyTheTitleOntoTheScene() {
        XCTAssertEqual(summary.title, context.scene.stubbedEventSummaryComponent.capturedTitle)
    }

    func testApplyTheSubtitleOntoTheScene() {
        XCTAssertEqual(summary.subtitle, context.scene.stubbedEventSummaryComponent.capturedSubtitle)
    }

    func testApplyTheAbstractOntoTheScene() {
        XCTAssertEqual(summary.abstract, context.scene.stubbedEventSummaryComponent.capturedAbstract)
    }

    func testApplyTheEventStartTimeOntoTheScene() {
        XCTAssertEqual(summary.eventStartEndTime, context.scene.stubbedEventSummaryComponent.capturedEventStartTime)
    }

    func testApplyTheEventLocationOntoTheScene() {
        XCTAssertEqual(summary.location, context.scene.stubbedEventSummaryComponent.capturedEventLocation)
    }

    func testApplyTheTrackNameOntoTheScene() {
        XCTAssertEqual(summary.trackName, context.scene.stubbedEventSummaryComponent.capturedTrackName)
    }

    func testApplyTheEventHostsOntoTheScene() {
        XCTAssertEqual(summary.eventHosts, context.scene.stubbedEventSummaryComponent.capturedEventHosts)
    }

    func testReturnTheBoundEventSummaryComponent() {
        XCTAssertTrue((boundComponent as? CapturingEventSummaryComponent) === context.scene.stubbedEventSummaryComponent)
    }

}