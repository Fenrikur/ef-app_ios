import UIKit

@available(iOS 14.0, *)
class ModernRootViewController: TabBarController {
    
    init(applicationModuleFactories: [ApplicationModuleFactory]) {
        super.init(nibName: nil, bundle: nil)
        
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = SplitViewController()
            let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
            splitViewController.viewControllers = [navigationController, noContentPlaceholder]
            splitViewController.tabBarItem = navigationController.tabBarItem
            
            return splitViewController
        }
        
        viewControllers = splitViewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
