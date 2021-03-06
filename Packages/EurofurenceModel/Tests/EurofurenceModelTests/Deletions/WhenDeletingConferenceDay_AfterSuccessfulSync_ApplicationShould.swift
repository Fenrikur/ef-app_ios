import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDeletingConferenceDay_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheDay() {
        let dataStore = InMemoryDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let dayToDelete = response.conferenceDays.changed.remove(at: 0)
        response.conferenceDays.deleted = [dayToDelete.identifier]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)

        XCTAssertEqual(false, dataStore.fetchConferenceDays()?.contains(dayToDelete))
    }

}
