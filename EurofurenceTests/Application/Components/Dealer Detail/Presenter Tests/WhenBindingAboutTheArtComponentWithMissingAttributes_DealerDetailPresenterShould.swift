@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtComponentWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    var context: DealerDetailPresenterTestBuilder.Context!
    var aboutTheArtViewModel: DealerDetailAboutTheArtViewModel!

    override func setUp() {
        super.setUp()

        aboutTheArtViewModel = DealerDetailAboutTheArtViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: aboutTheArtViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
    }

    func testTellTheSceneToHideTheArtDescription() {
        XCTAssertEqual(true, context.boundAboutTheArtComponent?.didHideAboutTheArtDescription)
    }

    func testTellTheSceneToHideTheArtPreview() {
        XCTAssertEqual(true, context.boundAboutTheArtComponent?.didHideArtPreview)
    }

    func testTellTheSceneToHideTheArtPreviewCaption() {
        XCTAssertEqual(true, context.boundAboutTheArtComponent?.didHideArtPreviewCaption)
    }

}