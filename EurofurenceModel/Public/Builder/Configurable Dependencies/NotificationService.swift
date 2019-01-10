//
//  NotificationService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 28/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public enum NotificationContent: Equatable {
    case successfulSync
    case failedSync
    case unknown
    case announcement(AnnouncementIdentifier)
    case invalidatedAnnouncement
    case event(EventIdentifier)
}

public protocol NotificationService {

    func storeRemoteNotificationsToken(_ deviceToken: Data)
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void)

}
