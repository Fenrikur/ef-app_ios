import Foundation

protocol MapDetailScene {

    func setDelegate(_ delegate: MapDetailSceneDelegate)
    func setMapImagePNGData(_ data: Data)
    func setMapTitle(_ title: String)
    func focusMapPosition(_ position: MapCoordinate)
    func show(contextualContent: MapInformationContextualContent)
    func showMapOptions(heading: String,
                        options: [String],
                        atX x: Float,
                        y: Float,
                        selectionHandler: @escaping (Int) -> Void)

}

protocol MapDetailSceneDelegate {

    func mapDetailSceneDidLoad()
    func mapDetailSceneDidTapMap(at position: MapCoordinate)

}

struct MapCoordinate: Equatable {
    var x: Float
    var y: Float
}

struct MapInformationContextualContent: Equatable {
    var coordinate: MapCoordinate
    var content: String
}

protocol MapContentOptionsViewModel {

    var optionsHeading: String { get }
    var options: [String] { get }

    func selectOption(at index: Int)

}
