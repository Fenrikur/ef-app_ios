import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        extendedLayoutIncludesOpaqueBars = true
        preferredDisplayMode = .allVisible
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        if let masterNavigation = viewControllers.first as? UINavigationController {
            masterNavigation.pushViewController(vc, animated: UIView.areAnimationsEnabled)
        } else {
            super.show(vc, sender: sender)
        }
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        if let detailNavigationController = viewControllers.last as? UINavigationController {
            var context = (sender as? DetailPresentationContext) ?? .show
            if traitCollection.horizontalSizeClass == .compact {
                context = .show
            }
            
            context.reveal(vc, in: detailNavigationController)
        } else {
            let navigationController = NavigationController(rootViewController: vc)
            super.showDetailViewController(navigationController, sender: self)
        }
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        secondaryViewController is NoContentPlaceholderViewController
    }
    
}
