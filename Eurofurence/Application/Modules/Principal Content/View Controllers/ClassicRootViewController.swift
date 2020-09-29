import UIKit

class ClassicRootViewController: TabBarController {
    
    init(applicationModuleFactories: [ApplicationModuleFactory]) {
        super.init(nibName: nil, bundle: nil)
        
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = SplitViewController()
            let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
            let noContentNavigation = UINavigationController(rootViewController: noContentPlaceholder)
            splitViewController.viewControllers = [navigationController, noContentNavigation]
            splitViewController.tabBarItem = navigationController.tabBarItem
            
            return splitViewController
        }
        
        viewControllers = splitViewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
