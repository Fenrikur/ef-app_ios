//
//  ScheduleSearchViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleSearchViewModel {

    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate)
    func updateSearchResults(input: String)
    func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier?
    func filterToFavourites()
    func filterToAllEvents()

}

protocol ScheduleSearchViewModelDelegate {

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel])

}
