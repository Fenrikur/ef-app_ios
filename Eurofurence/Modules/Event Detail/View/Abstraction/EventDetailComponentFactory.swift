//
//  EventDetailComponentFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventDetailComponentFactory {

    func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void)

}
