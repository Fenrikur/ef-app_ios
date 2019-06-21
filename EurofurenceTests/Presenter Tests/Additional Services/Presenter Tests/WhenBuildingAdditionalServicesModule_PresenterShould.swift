@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingAdditionalServicesModule_PresenterShould: XCTestCase {
    
    func testReturnInterfaceFromSceneFactory() {
        let context = AdditionalServicesPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }
    
    func testApplyTheShortTitleToTheScene() {
        let context = AdditionalServicesPresenterTestBuilder().build()
        XCTAssertEqual(.services, context.scene.capturedShortTitle)
    }
    
    func testApplyTheTitleToTheScene() {
        let context = AdditionalServicesPresenterTestBuilder().build()
        XCTAssertEqual(.additionalServices, context.scene.capturedTitle)
    }
    
}