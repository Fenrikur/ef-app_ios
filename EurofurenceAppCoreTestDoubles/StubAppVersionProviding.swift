//
//  StubAppVersionProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

public struct StubAppVersionProviding: AppVersionProviding {
    
    public var version: String

    public init(version: String) {
        self.version = version
    }
    
}
