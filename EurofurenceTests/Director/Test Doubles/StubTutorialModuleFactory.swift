@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubTutorialModuleFactory: TutorialComponentFactory {

    let stubInterface = UIViewController()
    private(set) var delegate: TutorialComponentDelegate?
    func makeTutorialModule(_ delegate: TutorialComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubTutorialModuleFactory {

    func simulateTutorialFinished() {
        delegate?.tutorialModuleDidFinishPresentingTutorial()
    }

}
