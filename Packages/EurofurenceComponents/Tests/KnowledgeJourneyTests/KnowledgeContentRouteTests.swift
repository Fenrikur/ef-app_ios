import KnowledgeGroupsComponent
import KnowledgeJourney
import XCTest

class KnowledgeContentRouteTests: XCTestCase {
    
    func testShowsKnowledge() {
        let presentation = CapturingKnowledgePresentation()
        let route = ScheduleRoute(presentation: presentation)
        
        XCTAssertFalse(presentation.didShowKnowledge)
        
        route.route(KnowledgeGroupsContentRepresentation())
        
        XCTAssertTrue(presentation.didShowKnowledge)
    }
    
}
