import UIKit

public struct PrincipalContentAggregator: PrincipalContentModuleProviding {
    
    private let applicationModuleFactories: [ApplicationModuleFactory]
    
    public init(applicationModuleFactories: [ApplicationModuleFactory]) {
        self.applicationModuleFactories = applicationModuleFactories
    }
    
    public func makePrincipalContentModule() -> UIViewController {
        if #available(iOS 14.0, *) {
            return ModernRootViewController(applicationModuleFactories: applicationModuleFactories)
        } else {
            return ClassicRootViewController(applicationModuleFactories: applicationModuleFactories)
        }
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
