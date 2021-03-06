import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel
import XCTRouter

class NewsSubrouterTests: XCTestCase {
    
    var router: FakeContentRouter!
    var subrouter: NewsSubrouter!
    
    override func setUp() {
        super.setUp()
        
        router = FakeContentRouter()
        subrouter = NewsSubrouter(router: router)
    }
    
    func testShowingPrivateMessages() {
        subrouter.newsModuleDidRequestShowingPrivateMessages()
        router.assertRouted(to: MessagesRouteable())
    }
    
    func testShowingAnnouncement() {
        let announcement = AnnouncementIdentifier.random
        subrouter.newsModuleDidSelectAnnouncement(announcement)
        
        router.assertRouted(to: AnnouncementRouteable(identifier: announcement))
    }
    
    func testShowingEvent() {
        let event = FakeEvent.random
        subrouter.newsModuleDidSelectEvent(event)
        
        router.assertRouted(to: EmbeddedEventRouteable(identifier: event.identifier))
    }
    
    func testShowingAnnouncements() {
        subrouter.newsModuleDidRequestShowingAllAnnouncements()
        router.assertRouted(to: AnnouncementsRouteable())
    }

}
