import Foundation

class MapsPresenter: MapsSceneDelegate {

    private struct Binder: MapsBinder {

        var viewModel: MapsViewModel

        func bind(_ component: MapComponent, at index: Int) {
            let map = viewModel.mapViewModel(at: index)

            component.setMapName(map.mapName)
            map.fetchMapPreviewPNGData(completionHandler: component.setMapPreviewImagePNGData)
        }

    }

    private let scene: MapsScene
    private let mapsViewModelFactory: MapsViewModelFactory
    private let delegate: MapsComponentDelegate
    private var viewModel: MapsViewModel?

    init(
        scene: MapsScene,
        mapsViewModelFactory: MapsViewModelFactory,
        delegate: MapsComponentDelegate
    ) {
        self.scene = scene
        self.mapsViewModelFactory = mapsViewModelFactory
        self.delegate = delegate

        scene.setMapsTitle(.maps)
        scene.setDelegate(self)
    }

    func mapsSceneDidLoad() {
        mapsViewModelFactory.makeMapsViewModel { (viewModel) in
            self.viewModel = viewModel
            self.scene.bind(numberOfMaps: viewModel.numberOfMaps, using: Binder(viewModel: viewModel))
        }
    }

    func simulateSceneDidSelectMap(at index: Int) {
        guard let identifier = viewModel?.identifierForMap(at: index) else { return }
        delegate.mapsComponentDidSelectMap(identifier: identifier)
    }

}
