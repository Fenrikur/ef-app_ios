import EurofurenceApplication
import EurofurenceApplicationSession
import UIKit

@available(iOS 13.0, *)
class PrincipalWindowSceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var principalWindowScene: WindowScene?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
#if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
#endif
        
        let principalWindowScene = Application.instance.configurePrincipalScene(window: window)
        self.principalWindowScene = principalWindowScene
        
        if let userActivity = connectionOptions.userActivities.first {
            Application.resume(activity: userActivity)
            principalWindowScene.resume(userActivity)
        }
        
        let URLContexts = connectionOptions.urlContexts
        if URLContexts.isEmpty == false {
            principalWindowScene.open(URLContexts: URLContexts)
        }
        
        window.installDebugModule()
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        principalWindowScene?.open(URLContexts: URLContexts)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        principalWindowScene?.resume(userActivity)
    }
    
}
