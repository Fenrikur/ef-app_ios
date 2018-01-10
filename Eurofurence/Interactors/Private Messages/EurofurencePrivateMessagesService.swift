//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class EurofurencePrivateMessagesService: PrivateMessagesService {

    static var shared = EurofurencePrivateMessagesService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol
    private var unreadMessageCountObservers = [PrivateMessagesServiceObserver]()

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    var localMessages: [Message] {
        return app.localPrivateMessages
    }

    func add(_ unreadMessageCountObserver: PrivateMessagesServiceObserver) {
        unreadMessageCountObservers.append(unreadMessageCountObserver)
        provideUnreadMessageCount(to: unreadMessageCountObserver)
    }

    func refreshMessages() {
        app.fetchPrivateMessages { (result) in
            switch result {
            case .success(let messages):
                self.unreadMessageCountObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages) })
                self.unreadMessageCountObservers.forEach(self.provideUnreadMessageCount)

            default:
                self.unreadMessageCountObservers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
            }
        }
    }

    private func isUnread(_ message: Message) -> Bool {
        return !message.isRead
    }

    private func provideUnreadMessageCount(to unreadMessageCountObserver: PrivateMessagesServiceObserver) {
        let count = app.localPrivateMessages.filter(isUnread).count
        unreadMessageCountObserver.privateMessagesServiceDidUpdateUnreadMessageCount(to: count)
    }

}
