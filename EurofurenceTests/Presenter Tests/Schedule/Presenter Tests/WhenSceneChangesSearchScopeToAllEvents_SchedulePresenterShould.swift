@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSceneChangesSearchScopeToAllEvents_SchedulePresenterShould: XCTestCase {

    func testTellTheSearchViewModelToFilterToFavourites() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()

        XCTAssertTrue(searchViewModel.didFilterToAllEvents)
    }

    func testTellTheSearchResultsToHide() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()

        XCTAssertTrue(context.scene.didHideSearchResults)
    }

    func testNotHideTheSearchResultsWhenQueryActive() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidUpdateSearchQuery("Something")
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()

        XCTAssertFalse(context.scene.didHideSearchResults)
    }

    func testNotTellTheSearchResultsToAppearWhenQueryChangesToEmptyString() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToAllEvents()
        context.scene.delegate?.scheduleSceneDidUpdateSearchQuery("")

        XCTAssertEqual(1, context.scene.didShowSearchResultsCount)
    }

}
