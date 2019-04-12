import EurofurenceModel

struct MessageDetailPresenter: MessageDetailSceneDelegate {

    private let message: Message
    private let scene: MessageDetailScene

    init(message: Message, scene: MessageDetailScene) {
        self.message = message
        self.scene = scene
        
        message.markAsRead()

        scene.delegate = self
    }

    func messageDetailSceneDidLoad() {
        scene.setMessageDetailTitle(message.authorName)
        scene.addMessageComponent(with: MessageBinder(message: message))
    }

    private struct MessageBinder: MessageComponentBinder {

        var message: Message

        func bind(_ component: MessageComponent) {
            component.setMessageSubject(message.subject)
            component.setMessageContents(message.contents)
        }

    }

}
