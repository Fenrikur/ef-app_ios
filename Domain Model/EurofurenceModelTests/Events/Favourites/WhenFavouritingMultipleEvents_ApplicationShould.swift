import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFavouritingMultipleEvents_ApplicationShould: XCTestCase {

    private func favouriteEvents(_ identifiers: [EventIdentifier], service: EventsService) {
        let events = identifiers.compactMap(service.fetchEvent)
        events.forEach({ $0.favourite() })
    }

    func testTellEventsObserversTheEventsAreNowFavouritedInTitleOrder() {
        var response = ModelCharacteristics.randomWithoutDeletions
        var firstEvent = response.events.changed[0]
        firstEvent.title = "Z"
        var secondEvent = response.events.changed[1]
        secondEvent.title = "A"
        let events = [firstEvent, secondEvent]
        response.events = .init(changed: events, deleted: [], removeAllBeforeInsert: false)
        let dataStore = InMemoryDataStore(response: response)

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifiers = events.map({ EventIdentifier($0.identifier) })
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        favouriteEvents(identifiers, service: context.eventsService)
        
        let expected = [secondEvent.identifier, firstEvent.identifier].map(EventIdentifier.init)

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

    func testTellEventsObserversWhenOnlyOneEventHasBeenUnfavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = InMemoryDataStore(response: response)

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifiers = events.map({ EventIdentifier($0.identifier) })
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        favouriteEvents(identifiers, service: context.eventsService)
        let randomIdentifier = identifiers.randomElement()
        let event = context.eventsService.fetchEvent(identifier: randomIdentifier.element)
        event?.unfavourite()
        var expected = identifiers
        expected.remove(at: randomIdentifier.index)

        XCTAssertEqual(Set(expected), Set(observer.capturedFavouriteEventIdentifiers))
    }

    func testSortTheFavouriteIdentifiersByEventStartTime() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            events.map({ EventIdentifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(Set(expected), Set(observer.capturedFavouriteEventIdentifiers))
    }

}
