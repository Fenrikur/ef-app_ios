//
//  EventDetailComponentFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventDetailComponentFactory {

    associatedtype Component

    func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> Component
    func makeEventDescriptionComponent(configuringUsing block: (EventDescriptionComponent) -> Void) -> Component
    func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> Component
    func makeSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component

}
