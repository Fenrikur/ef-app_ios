//
//  CapturingSyncAPI.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingSyncAPI: SyncAPI {

    fileprivate var completionHandler: ((ModelCharacteristics?) -> Void)?
    private(set) var capturedLastSyncTime: Date?
    private(set) var didBeginSync = false
    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {
        didBeginSync = true
        capturedLastSyncTime = lastSyncTime
        self.completionHandler = completionHandler
    }

}

extension CapturingSyncAPI {

    func simulateSuccessfulSync(_ response: ModelCharacteristics) {
        completionHandler?(response)
    }
    func simulateUnsuccessfulSync() {
        completionHandler?(nil)
    }

}
