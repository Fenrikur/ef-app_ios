import UIKit.UIStoryboard
import UIKit.UIViewController

struct StoryboardPreloadSceneFactory: PreloadSceneFactory {

    private let storyboard = UIStoryboard(name: "Preload", bundle: .main)

    func makePreloadScene() -> UIViewController & SplashScene {
        return storyboard.instantiate(PreloadViewController.self)
    }

}
