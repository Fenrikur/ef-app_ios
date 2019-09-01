import EurofurenceModel
import XCTest

class WhenObservingFavouriteEvent_ThenReAddingSameObserver: XCTestCase {

    func testTheObserverIsNotToldAboutTheSameEventStateAgain() {
        let context = EurofurenceSessionTestBuilder().build()
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let event = characteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: characteristics)
        let entity = context.eventsService.fetchEvent(identifier: EventIdentifier(event.identifier))
        let observer = NotToldAboutFavouriteStateMultipleTimes()
        entity?.add(observer)
        entity?.favourite()
        entity?.add(observer)
        
        observer.assert()
    }
    
    private class NotToldAboutFavouriteStateMultipleTimes: CapturingEventObserver {
        
        private var pass = true
        
        override func eventDidBecomeFavourite(_ event: Event) {
            pass = eventFavouriteState != .favourite
            super.eventDidBecomeFavourite(event)
        }
        
        func assert(_ line: UInt = #line) {
            XCTAssert(
                pass,
                "Adding the same observer to an event should not re-emit the same state",
                file: #file,
                line: line
            )
        }
        
    }

}
