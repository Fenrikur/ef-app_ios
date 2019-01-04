//
//  PrivateMessagesService2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol PrivateMessagesService2 {
    
    var localPrivateMessages: [APIMessage] { get }
    
    func refreshMessages()
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void)
    
    func markMessageAsRead(_ message: APIMessage)
    func add(_ observer: PrivateMessagesObserver)
    
}
