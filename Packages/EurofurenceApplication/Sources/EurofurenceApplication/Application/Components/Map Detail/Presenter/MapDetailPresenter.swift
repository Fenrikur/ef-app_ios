import EurofurenceModel
import Foundation

class MapDetailPresenter: MapDetailSceneDelegate {

    private weak var scene: MapDetailScene?
    private let mapDetailViewModelFactory: MapDetailViewModelFactory
    private let identifier: MapIdentifier
    private let delegate: MapDetailComponentDelegate
    private var viewModel: MapDetailViewModel?

    init(scene: MapDetailScene,
         mapDetailViewModelFactory: MapDetailViewModelFactory,
         identifier: MapIdentifier,
         delegate: MapDetailComponentDelegate) {
        self.scene = scene
        self.mapDetailViewModelFactory = mapDetailViewModelFactory
        self.identifier = identifier
        self.delegate = delegate

        scene.setDelegate(self)
    }

    func mapDetailSceneDidLoad() {
        mapDetailViewModelFactory.makeViewModelForMap(
            identifier: identifier,
            completionHandler: viewModelReady
        )
    }

    func mapDetailSceneDidTapMap(at position: MapCoordinate) {
        let (x, y) = (position.x, position.y)
        let visitor = ContentsVisitor(scene: scene, delegate: delegate, x: x, y: y)
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
    }

    private func viewModelReady(_ viewModel: MapDetailViewModel) {
        self.viewModel = viewModel

        scene?.setMapImagePNGData(viewModel.mapImagePNGData)
        scene?.setMapTitle(viewModel.mapName)
    }

    private struct ContentsVisitor: MapContentVisitor {

        var scene: MapDetailScene?
        var delegate: MapDetailComponentDelegate
        var x: Float
        var y: Float

        func visit(_ mapPosition: MapCoordinate) {
            scene?.focusMapPosition(mapPosition)
        }

        func visit(_ content: MapInformationContextualContent) {
            scene?.show(contextualContent: content)
        }

        func visit(_ dealer: DealerIdentifier) {
            delegate.mapDetailModuleDidSelectDealer(dealer)
        }

        func visit(_ mapContents: MapContentOptionsViewModel) {
            scene?.showMapOptions(heading: mapContents.optionsHeading,
                                 options: mapContents.options,
                                 atX: x,
                                 y: y,
                                 selectionHandler: mapContents.selectOption)
        }

    }

}
