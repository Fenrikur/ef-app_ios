//
//  WhenSyncSucceeds_WithImages_ThenSubsequentSyncDeletesImage_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSyncSucceeds_WithImages_ThenSubsequentSyncDeletesImage_ApplicationShould: XCTestCase {

    func testDeleteTheImageFromTheStore() {
        let dataStore = FakeDataStore()
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let imageToDelete = syncResponse.images.changed.randomElement().element
        syncResponse.images.changed.removeAll()
        syncResponse.images.deleted = [imageToDelete.identifier]
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertEqual(false, dataStore.fetchImages()?.contains(imageToDelete))
        XCTAssertTrue(context.imageRepository.deletedImages.contains(imageToDelete.identifier))
    }

}
