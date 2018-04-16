//
//  NewsComponentsBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSIndexPath

protocol NewsComponentsBinder {

    func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene)
    func bindComponent(at indexPath: IndexPath, using componentFactory: NewsComponentFactory)

}

protocol NewsComponentFactory {

    func makeAnnouncementComponent() -> NewsAnnouncementComponent
    func makeEventComponent() -> NewsEventComponent

}

protocol NewsAnnouncementComponent {

    func setAnnouncementTitle(_ title: String)
    func setAnnouncementDetail(_ detail: String)

}

protocol NewsEventComponent {

    func setEventStartTime(_ startTime: String)

}
