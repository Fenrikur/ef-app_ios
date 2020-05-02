import Foundation
import UIKit.UIViewController

public struct LoginContentRoute {
    
    private let loginModuleFactory: LoginModuleProviding
    private let modalWireframe: ModalWireframe
    
    public init(
        loginModuleFactory: LoginModuleProviding,
        modalWireframe: ModalWireframe
    ) {
        self.loginModuleFactory = loginModuleFactory
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - ContentRoute

extension LoginContentRoute: ContentRoute {
    
    public typealias Content = LoginContentRepresentation
    
    public func route(_ content: LoginContentRepresentation) {
        let delegate = MapResponseToBlock(completionHandler: content.completionHandler)
        let contentController = loginModuleFactory.makeLoginModule(delegate)
        delegate.viewController = contentController
        
        modalWireframe.presentModalContentController(contentController)
    }
    
    private class MapResponseToBlock: LoginModuleDelegate {
        
        private let completionHandler: (Bool) -> Void
        var viewController: UIViewController?
        
        init(completionHandler: @escaping (Bool) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func loginModuleDidCancelLogin() {
            completionHandler(false)
            viewController?.dismiss(animated: true)
        }
        
        func loginModuleDidLoginSuccessfully() {
            completionHandler(true)
        }
        
    }
    
}
