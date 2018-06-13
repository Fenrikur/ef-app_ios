//
//  ScheduleDaysBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleDaysBinder {

    func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int)

}
