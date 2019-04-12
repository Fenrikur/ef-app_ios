import EurofurenceModel
import XCTest

class WhenSyncSuceeds_ThenObservingUpcomingEvents: XCTestCase {

    func testTheObserverIsProvidedWithTheUpcomingEvents() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.upcomingEvents, containsEventCharacterisedBy: randomEvent)
    }

}
