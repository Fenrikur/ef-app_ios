import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTEurofurenceModel

class StubMessagesComponentFactory: MessagesComponentFactory {

    let stubInterface = UIViewController()
    private(set) var delegate: MessagesComponentDelegate?
    func makeMessagesModule(_ delegate: MessagesComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMessagesComponentFactory {

    func simulateMessagePresentationRequested(_ message: MessageIdentifier) {
        delegate?.messagesModuleDidRequestPresentation(for: message)
    }

    func simulateDismissalRequested() {
        delegate?.messagesModuleDidRequestDismissal()
    }

}
