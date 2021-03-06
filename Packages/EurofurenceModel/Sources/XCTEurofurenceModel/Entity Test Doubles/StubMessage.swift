import EurofurenceModel
import Foundation
import TestUtilities

public final class StubMessage: Message {

    public var identifier: MessageIdentifier
    public var authorName: String
    public var receivedDateTime: Date
    public var subject: String
    public var contents: String
    public var isRead: Bool
    
    private var observers: [PrivateMessageObserver] = []

    public init(identifier: MessageIdentifier,
                authorName: String,
                receivedDateTime: Date,
                subject: String,
                contents: String,
                isRead: Bool) {
        self.identifier = identifier
        self.authorName = authorName
        self.receivedDateTime = receivedDateTime
        self.subject = subject
        self.contents = contents
        self.isRead = isRead
    }
    
    public func add(_ observer: PrivateMessageObserver) {
        observers.append(observer)
        
        if isRead {
            observer.messageMarkedRead()
        } else {
            observer.messageMarkedUnread()
        }
    }
    
    public func remove(_ observer: PrivateMessageObserver) {
        observers.removeAll(where: { $0 === observer })
    }
    
    public private(set) var markedRead = false
    public func markAsRead() {
        markedRead = true
    }
    
    public func transitionToUnreadState() {
        isRead = false
        for observer in observers {
            observer.messageMarkedUnread()
        }
    }
    
    public func transitionToReadState() {
        isRead = true
        for observer in observers {
            observer.messageMarkedRead()
        }
    }

}

extension StubMessage: RandomValueProviding {

    public static var random: StubMessage {
        return StubMessage(identifier: .random,
                           authorName: .random,
                           receivedDateTime: .random,
                           subject: .random,
                           contents: .random,
                           isRead: .random)
    }

}
