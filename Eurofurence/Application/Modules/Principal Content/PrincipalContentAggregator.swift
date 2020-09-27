import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let applicationModuleFactories: [ApplicationModuleFactory]
    
    public init(applicationModuleFactories: [ApplicationModuleFactory]) {
        self.applicationModuleFactories = applicationModuleFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = SplitViewController()
            let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
            splitViewController.viewControllers = [navigationController, noContentPlaceholder]
            splitViewController.tabBarItem = navigationController.tabBarItem
            
            return splitViewController
        }
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = splitViewControllers
        
        return tabBarController
    }
    
}

// MARK: - DetailPresentationContext Revealing

extension DetailPresentationContext {
    
    func reveal(_ viewController: UIViewController, in navigationController: UINavigationController) {
        guard navigationController.viewControllers.contains(viewController) == false else { return }
        
        switch self {
        case .show:
            navigationController.pushViewController(viewController, animated: UIView.areAnimationsEnabled)
            
        case .replace:
            navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
}
