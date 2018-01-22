//
//  LoginResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol LoginResponse {

    var uid: String { get }
    var username: String { get }
    var token: String { get }
    var tokenValidUntil: Date { get }

}
