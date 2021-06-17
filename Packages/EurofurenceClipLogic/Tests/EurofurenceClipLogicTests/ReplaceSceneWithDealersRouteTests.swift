import DealersComponent
import EurofurenceClipLogic
import XCTest

class ReplaceSceneWithDealersRouteTests: XCTestCase {
    
    func testReplacesSceneWithDealers() {
        let scene = MockClipFallbackContent()
        let route = ReplaceSceneWithDealersRoute(scene: scene)
        route.route(DealersContentRepresentation())
        
        scene.assertDisplaying(.dealers)
    }
    
}
