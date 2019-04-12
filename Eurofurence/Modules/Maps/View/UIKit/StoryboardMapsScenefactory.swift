import UIKit

struct StoryboardMapsScenefactory: MapsSceneFactory {

    private let storyboard = UIStoryboard(name: "Maps", bundle: .main)

    func makeMapsScene() -> UIViewController & MapsScene {
        return storyboard.instantiate(MapsViewController.self)
    }

}
