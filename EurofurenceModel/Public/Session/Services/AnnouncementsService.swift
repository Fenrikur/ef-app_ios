//
//  AnnouncementsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol AnnouncementsService {
    
    func add(_ observer: AnnouncementsServiceObserver)
    func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement?

}

public protocol AnnouncementsServiceObserver {

    func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement])
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier])

}
