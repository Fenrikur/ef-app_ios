import UIKit

public struct WindowAlertRouter: AlertRouter {

    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
    }

    public func show(_ alert: Alert) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        for action in alert.actions {
            alertController.addAction(UIAlertAction(title: action.title, style: .default, handler: { (_) in
                action.invoke()
                alertController.dismiss(animated: true)
            }))
        }

        var presenting: UIViewController? = window.rootViewController
        if let presented = presenting?.presentedViewController {
            presenting = presented
        }

        presenting?.present(alertController, animated: true) {
            alert.onCompletedPresentation?(Dismissable(viewController: presenting))
        }
    }

    private struct Dismissable: AlertDismissable {

        var viewController: UIViewController?

        func dismiss(_ completionHandler: (() -> Void)?) {
            viewController?.dismiss(animated: true, completion: completionHandler)
        }

    }

}
