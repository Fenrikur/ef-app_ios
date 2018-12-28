//
//  WhenDeletingKnowledgeEntry_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenDeletingKnowledgeEntry_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheEntry() {
        let dataStore = CapturingEurofurenceDataStore()
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let entryToDelete = String.random
        response.knowledgeEntries.deleted = [entryToDelete]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)

        XCTAssertEqual([entryToDelete], dataStore.transaction.deletedKnowledgeEntries)
    }

}