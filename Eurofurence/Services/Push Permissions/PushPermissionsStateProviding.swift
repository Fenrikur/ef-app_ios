//
//  PushPermissionsStateProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol PushPermissionsStateProviding {

    var requestedPushNotificationAuthorization: Bool { get }

    func attemptedPushAuthorizationRequest()

}
