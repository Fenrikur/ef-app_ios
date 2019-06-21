import Foundation

protocol HybridWebScene {

    func setDelegate(_ delegate: HybridWebSceneDelegate)
    func setSceneShortTitle(_ shortTitle: String)
    func setSceneTitle(_ title: String)
    func setSceneIcon(pngData: Data)
    func loadContents(of urlRequest: URLRequest)

}

protocol HybridWebSceneDelegate {

    func hybridWebSceneDidLoad()

}