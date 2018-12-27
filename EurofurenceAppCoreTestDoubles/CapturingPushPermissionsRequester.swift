//
//  CapturingPushPermissionsRequester.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

public class CapturingPushPermissionsRequester: PushPermissionsRequester {

    public init() {

    }

    private(set) public var wasToldToRequestPushPermissions = false
    public func requestPushPermissions() {
        wasToldToRequestPushPermissions = true
    }

}
