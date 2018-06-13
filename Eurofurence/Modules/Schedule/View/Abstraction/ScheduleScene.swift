//
//  ScheduleScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol ScheduleScene {

    func setDelegate(_ delegate: ScheduleSceneDelegate)
    func setScheduleTitle(_ title: String)
    func bind(numberOfItemsPerSection: [Int])

}

protocol ScheduleSceneDelegate {

    func scheduleSceneDidLoad()

}
