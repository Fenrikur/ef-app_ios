import UIKit.UIViewController

public struct EventFeedbackContentRoute {
    
    private let eventFeedbackFactory: EventFeedbackModuleProviding
    private let modalWireframe: ModalWireframe
    
    public init(eventFeedbackFactory: EventFeedbackModuleProviding, modalWireframe: ModalWireframe) {
        self.eventFeedbackFactory = eventFeedbackFactory
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - ContentRoute

extension EventFeedbackContentRoute: ContentRoute {
    
    public typealias Content = EventFeedbackContentRepresentation
    
    public func route(_ content: EventFeedbackContentRepresentation) {
        let delegate = DismissControllerWhenCancellingFeedback()
        let contentController = eventFeedbackFactory.makeEventFeedbackModule(
            for: content.identifier,
            delegate: delegate
        )
        
        delegate.viewController = contentController
        
        modalWireframe.presentModalContentController(contentController)
    }
    
    private class DismissControllerWhenCancellingFeedback: EventFeedbackModuleDelegate {
        
        var viewController: UIViewController?
        
        func eventFeedbackCancelled() {
            viewController?.dismiss(animated: true)
        }
        
    }
    
}
