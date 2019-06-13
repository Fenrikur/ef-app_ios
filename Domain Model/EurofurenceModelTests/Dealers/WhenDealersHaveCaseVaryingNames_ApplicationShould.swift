import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealersHaveCaseVaryingNames_ApplicationShould: XCTestCase {

    func testGroupThemTogetherUsingTheCapitalForm() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstDealer = DealerCharacteristics.random
        firstDealer.displayName = "Barry"
        var secondDealer = DealerCharacteristics.random
        secondDealer.displayName = "barry"
        syncResponse.dealers.changed = [firstDealer, secondDealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let group = delegate.capturedAlphabetisedDealerGroups.first

        XCTAssertEqual("B", group?.indexingString)
        XCTAssertEqual(2, group?.dealers.count)
    }

}