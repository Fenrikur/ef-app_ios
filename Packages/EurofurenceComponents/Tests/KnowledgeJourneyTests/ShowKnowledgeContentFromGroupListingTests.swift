import EurofurenceModel
import KnowledgeDetailComponent
import KnowledgeJourney
import XCTComponentBase
import XCTest
import XCTEurofurenceModel
import XCTRouter

class ShowKnowledgeContentFromGroupListingTests: XCTestCase {

    func testShowsKnowledgeEntryContent() {
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        let router = FakeContentRouter()
        let navigator = ShowKnowledgeContentFromGroupListing(router: router)
        navigator.knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: knowledgeEntry)
        
        router.assertRouted(to: KnowledgeEntryRouteable(identifier: knowledgeEntry))
    }

}
