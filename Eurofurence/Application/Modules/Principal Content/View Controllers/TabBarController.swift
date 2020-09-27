import UIKit

class TabBarController: UITabBarController {
    
    override func show(_ vc: UIViewController, sender: Any?) {
        selectedViewController?.show(vc, sender: sender)
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        selectedViewController?.showDetailViewController(vc, sender: sender)
    }
    
}
