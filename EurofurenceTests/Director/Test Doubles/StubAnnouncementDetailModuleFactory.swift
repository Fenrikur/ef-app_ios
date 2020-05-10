@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubAnnouncementDetailModuleFactory: AnnouncementDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: AnnouncementIdentifier?
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        capturedModel = announcement
        return stubInterface
    }

}
