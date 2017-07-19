//
//  JSONPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol JSONPoster {

    func post(_ request: POSTRequest, completionHandler: @escaping (Data?) -> Void)

}

struct POSTRequest {

    var url: String
    var body: Data
    var headers: [String : String]

    init(url: String, body: Data, headers: [String : String] = [:]) {
        self.url = url
        self.body = body
        self.headers = headers
    }

}
