import UIKit

@available(iOS 14.0, *)
class ModernRootViewController: UISplitViewController {
    
    init(applicationModuleFactories: [ApplicationModuleFactory]) {
        super.init(style: .tripleColumn)
        
        preferredDisplayMode = .allVisible
        preferredSplitBehavior = .tile
        
        let applicationModules = applicationModuleFactories.map({ $0.makeApplicationModuleController() })
        
        let navigationOptions = applicationModules.map({ (viewController) in
            NavigationOption(viewController: viewController, selectionHandler: self.showNavigationOption)
        })
        
        let sidebarViewController = SidebarViewController(options: navigationOptions)
        let sidebarNavigationWrapper = NavigationController(rootViewController: sidebarViewController)
        setViewController(sidebarNavigationWrapper, for: .primary)
        
        showNavigationOption(navigationOptions.first.unsafelyUnwrapped)
        show(.primary)
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        if let masterNavigation = viewController(for: .supplementary) as? UINavigationController {
            masterNavigation.pushViewController(vc, animated: UIView.areAnimationsEnabled)
        } else {
            super.show(vc, sender: sender)
        }
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        if let detailNavigationController = viewController(for: .secondary) as? UINavigationController {
            var context = (sender as? DetailPresentationContext) ?? .show
            if traitCollection.horizontalSizeClass == .compact {
                context = .show
            }
            
            context.reveal(vc, in: detailNavigationController)
        } else {
            let navigationController = NavigationController(rootViewController: vc)
            setViewController(navigationController, for: .secondary)
        }
    }
    
    private func showNavigationOption(_ item: NavigationOption) {
        viewControllerSelected(item.viewController)
    }
    
    private func viewControllerSelected(_ viewController: UIViewController) {
        setViewController(NavigationController(rootViewController: viewController), for: .supplementary)
        setViewController(NavigationController(rootViewController: NoContentPlaceholderViewController.fromStoryboard()), for: .secondary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct NavigationOption {
        
        var viewController: UIViewController
        var title: String
        var image: UIImage
        private let selectionHandler: (NavigationOption) -> Void
        
        init(viewController: UIViewController, selectionHandler: @escaping (NavigationOption) -> Void) {
            self.viewController = viewController
            title = viewController.tabBarItem.title.unsafelyUnwrapped
            image = viewController.tabBarItem.image.unsafelyUnwrapped
            self.selectionHandler = selectionHandler
        }
        
        func select() {
            selectionHandler(self)
        }
        
    }
    
    private class SidebarCell: UICollectionViewListCell {
        
        var navigationOption: NavigationOption? {
            didSet {
                setNeedsUpdateConfiguration()
            }
        }
        
        override func updateConfiguration(using state: UICellConfigurationState) {
            defer {
                super.updateConfiguration(using: state)
            }
            
            guard let navigationOption = navigationOption else { return }
            
            var content = UIListContentConfiguration.sidebarCell().updated(for: state)
            content.text = navigationOption.title
            content.image = navigationOption.image
            
            var imageProperties = content.imageProperties
            imageProperties.tintColor = .unselectedTabBarItem
            
            var background = UIBackgroundConfiguration.listSidebarCell()
            
            if state.isSelected {
                imageProperties.tintColor = .white
                background.backgroundColor = .pantone330U_45
            }
            
            if state.isHighlighted {
                background.backgroundColor = .pantone330U_13
            }
            
            content.imageProperties = imageProperties
            
            backgroundConfiguration = background
            contentConfiguration = content
        }
        
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
            
            collectionView.register(SidebarCell.self, forCellWithReuseIdentifier: cellIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            collectionView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
            navigationItem.title = "Eurofurence"
        }
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            options.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            let listCell = unsafeDowncast(cell, to: SidebarCell.self)
            
            let option = options[indexPath.item]
            listCell.navigationOption = option
            
            return listCell
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let option = options[indexPath.item]
            option.select()
        }
        
    }
    
}
