//
//  WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups: XCTestCase {
    
    func testTheGroupsFromTheStoreAreAdaptedInOrder() {
        let dataStore = CapturingEurofurenceDataStore()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let expected = context.expectedKnowledgeGroups(from: syncResponse)
        
        var actual: [KnowledgeGroup2] = []
        context.application.fetchKnowledgeGroups { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
