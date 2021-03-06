import ComponentBase
import ContentController
import DealerComponent
import DealersComponent
import EurofurenceApplicationSession
import EurofurenceModel
import UIKit

struct DealerAppClipModule: PrincipalContentModuleFactory {
    
    var services: Services
    var window: UIWindow
    var windowScene: UIWindowScene
    
    func makePrincipalContentModule() -> UIViewController {
        let rootViewController = BrandedSplitViewController()
        
        let dealersViewModelFactory = DefaultDealersViewModelFactory(
            dealersService: services.dealers,
            refreshService: services.refresh
        )
        
        let dealersComponentFactory = DealersComponentBuilder(
            dealersViewModelFactory: dealersViewModelFactory
        ).build()
        
        let shareService = ActivityShareService(window: window)
        let dealerDetailViewModelFactory = DefaultDealerDetailViewModelFactory(
            dealersService: services.dealers,
            shareService: shareService
        )
        
        let dealerInteractionRecorder = DonateIntentDealerInteractionRecorder(
            viewDealerIntentDonor: DonateFromAppDealerIntentDonor(),
            dealersService: services.dealers,
            activityFactory: PlatformActivityFactory()
        )

        let dealerDetailModuleProviding = DealerDetailComponentBuilder(
            dealerDetailViewModelFactory: dealerDetailViewModelFactory,
            dealerInteractionRecorder: dealerInteractionRecorder
        ).build()
        
        let showDealerInDetailPane = ShowDealerInDetailPane(
            splitViewController: rootViewController,
            dealerDetailModuleProviding: dealerDetailModuleProviding
        )
        
        let dealersModule = dealersComponentFactory.makeDealersComponent(showDealerInDetailPane)
        let dealersNavigationController = BrandedNavigationController(rootViewController: dealersModule)
        let placeholderViewController = NoContentPlaceholderViewController.fromStoryboard()
        let placeholderNavigation = BrandedNavigationController(rootViewController: placeholderViewController)
        
        rootViewController.viewControllers = [dealersNavigationController, placeholderNavigation]
        
        return rootViewController
    }
    
}
