import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingDaysBeforeRefreshWhenStoreHasConferenceDays: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let delegate = CapturingEventsScheduleDelegate()
        let schedule = context.eventsService.makeEventsSchedule()
        schedule.setDelegate(delegate)

        DayAssertion()
            .assertDays(delegate.allDays, characterisedBy: response.conferenceDays.changed)
    }

}
