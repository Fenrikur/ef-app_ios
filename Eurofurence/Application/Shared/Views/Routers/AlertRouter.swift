import Foundation

protocol AlertRouter {

    func show(_ alert: Alert)

}

protocol AlertDismissable {

    func dismiss(_ completionHandler: (() -> Void)?)

}

extension AlertDismissable {

    func dismiss() {
        dismiss(nil)
    }

}

struct Alert {

    var title: String
    var message: String
    var actions: [AlertAction]
    var onCompletedPresentation: ((AlertDismissable) -> Void)?

    init(title: String, message: String, actions: [AlertAction] = []) {
        self.title = title
        self.message = message
        self.actions = actions
    }

}

struct AlertAction {

    var title: String
    private var action: (() -> Void)?

    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    func invoke() {
        action?()
    }

}