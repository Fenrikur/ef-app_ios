//
//  WhenFetchingKnowledgeGroup_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenFetchingKnowledgeGroup_ApplicationShould: XCTestCase {
    
    func testReturnOnlyEntriesForThatGroup() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomGroup = syncResponse.knowledgeGroups.changed.randomElement()
        let expected = context.expectedKnowledgeGroup(from: randomGroup.element, syncResponse: syncResponse)
        
        var actual: KnowledgeGroup2?
        context.application.fetchKnowledgeGroup(identifier: KnowledgeGroup2.Identifier(randomGroup.element.identifier)) { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
