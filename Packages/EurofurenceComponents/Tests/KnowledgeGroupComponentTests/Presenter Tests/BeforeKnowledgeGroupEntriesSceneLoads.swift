import EurofurenceModel
import KnowledgeGroupComponent
import XCTest

class BeforeKnowledgeGroupEntriesSceneLoads: XCTestCase {

    func testNoBindingsOccurOntoTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        XCTAssertNil(context.sceneFactory.scene.capturedNumberOfEntriesToBind)
    }

}
