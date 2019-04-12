@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_MapDetailInteractorShould: XCTestCase {

    func testPrepareViewModelWithTitleForSpecifiedMap() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        XCTAssertEqual(randomMap.element.location, viewModel?.mapName)
    }

    func testPrepareViewModelWithMapGraphicData() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let interactor = DefaultMapDetailInteractor(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        interactor.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        XCTAssertEqual(randomMap.element.imagePNGData, viewModel?.mapImagePNGData)
    }

}
