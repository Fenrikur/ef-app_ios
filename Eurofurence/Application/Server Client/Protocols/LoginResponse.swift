//
//  LoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct LoginResponse {

    var userIdentifier: String
    var username: String
    var token: String
    var tokenValidUntil: Date

}