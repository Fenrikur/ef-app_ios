import EurofurenceModel
import KnowledgeDetailComponent
import XCTest

class WhenShowingKnowledgeEntryWithoutLinks: XCTestCase {

    func testTheSceneIsNotToldToShowLinks() {
        let viewModelFactory = StubKnowledgeDetailViewModelFactory()
        viewModelFactory.viewModel = .randomWithoutLinks
        let context = KnowledgeDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.knowledgeDetailScene.simulateSceneDidLoad()

        XCTAssertNil(context.knowledgeDetailScene.linksToPresent)
    }

}
