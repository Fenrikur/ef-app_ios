//
//  WhenFetchingImagesForKnowledgeEntry_WhenEntryHasNoImages_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingImagesForKnowledgeEntry_WhenEntryHasNoImages_ApplicationShould: XCTestCase {
    
    func testInvokeTheHandlerWithEmptyImages() {
        let context = ApplicationTestBuilder().build()
        var images: [Data]?
        context.application.fetchImagesForKnowledgeEntry(identifier: .random) { images = $0 }
        
        XCTAssertEqual([], images)
    }
    
}