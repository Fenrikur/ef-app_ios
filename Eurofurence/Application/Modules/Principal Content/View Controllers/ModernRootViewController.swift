import UIKit

@available(iOS 14.0, *)
class ModernRootViewController: UISplitViewController {
    
    init(applicationModuleFactories: [ApplicationModuleFactory]) {
        super.init(style: .tripleColumn)
        
        preferredSplitBehavior = .tile
        
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        let navigationControllers = applicationModules.map(NavigationController.init)
        let splitViewControllers = navigationControllers.map { (navigationController) -> UISplitViewController in
            let splitViewController = SplitViewController()
            let noContentPlaceholder = NoContentPlaceholderViewController.fromStoryboard()
            splitViewController.viewControllers = [navigationController, noContentPlaceholder]
            splitViewController.tabBarItem = navigationController.tabBarItem
            
            return splitViewController
        }
        
        let navigationOptions = applicationModules.map({ (viewController) in
            NavigationOption(
                title: viewController.tabBarItem.title.unsafelyUnwrapped,
                image: viewController.tabBarItem.image.unsafelyUnwrapped,
                selectionHandler: {
                    self.viewControllerSelected(viewController)
                }
            )
        })
        
        let sidebarViewController = SidebarViewController(options: navigationOptions)
        let sidebarNavigationWrapper = NavigationController(rootViewController: sidebarViewController)
        setViewController(sidebarNavigationWrapper, for: .primary)
    }
    
    private func viewControllerSelected(_ viewController: UIViewController) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct NavigationOption {
        
        var title: String
        var image: UIImage
        var selectionHandler: () -> Void
        
    }
    
    private class SidebarViewController: UICollectionViewController {
        
        private let options: [NavigationOption]
        private let cellIdentifier = "Cell"
        
        init(options: [NavigationOption]) {
            self.options = options
            
            let layout = UICollectionViewCompositionalLayout { (_, layoutEnvironment) in
                let config = UICollectionLayoutListConfiguration(appearance: .sidebar)
                return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            }
            
            super.init(collectionViewLayout: layout)
            
            collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "Eurofurence"
        }
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            options.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let listCell = unsafeDowncast(cell, to: UICollectionViewListCell.self)
            
            let option = options[indexPath.item]
            var configuration = UIListContentConfiguration.sidebarCell()
            configuration.text = option.title
            configuration.image = option.image
            
            var imageProperties = configuration.imageProperties
            imageProperties.tintColor = .unselectedTabBarItem
            configuration.imageProperties = imageProperties
            
            listCell.contentConfiguration = configuration
            return listCell
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let option = options[indexPath.item]
            option.selectionHandler()
        }
        
    }
    
}
