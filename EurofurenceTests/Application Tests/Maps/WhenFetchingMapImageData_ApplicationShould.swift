//
//  WhenFetchingMapImageData_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingMapImageData_ApplicationShould: XCTestCase {
    
    func testReturnTheDataForTheMapsImageIdentifier() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let randomMap = syncResponse.maps.changed.randomElement()
        var mapImageData: Data?
        context.application.fetchImagePNGDataForMap(identifier: Map2.Identifier(randomMap.element.identifier)) { mapImageData = $0 }
        let imageEntity = context.imageRepository.loadImage(identifier: randomMap.element.imageIdentifier)
        
        XCTAssertEqual(imageEntity?.pngImageData, mapImageData)
    }
    
}