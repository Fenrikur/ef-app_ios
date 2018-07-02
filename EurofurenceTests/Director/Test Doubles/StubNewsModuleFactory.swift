//
//  StubNewsModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubNewsModuleFactory: NewsModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: NewsModuleDelegate?
    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubNewsModuleFactory {
    
    func simulatePrivateMessagesDisplayRequested() {
        delegate?.newsModuleDidRequestShowingPrivateMessages()
    }
    
    func simulateDidSelectAnnouncement(_ announcement: Announcement2) {
        delegate?.newsModuleDidSelectAnnouncement(announcement)
    }
    
    func simulateDidSelectEvent(_ event: Event2) {
        delegate?.newsModuleDidSelectEvent(event)
    }
    
    func simulateAllAnnouncementsDisplayRequested() {
        delegate?.newsModuleDidRequestShowingAllAnnouncements()
    }
    
}
