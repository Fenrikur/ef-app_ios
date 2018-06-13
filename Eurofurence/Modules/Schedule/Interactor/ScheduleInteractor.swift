//
//  ScheduleInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleInteractor {

    func setDelegate(_ delegate: ScheduleInteractorDelegate)

}

protocol ScheduleInteractorDelegate {

    func scheduleInteractorDidPrepareViewModel(_ viewModel: ScheduleViewModel)

}
