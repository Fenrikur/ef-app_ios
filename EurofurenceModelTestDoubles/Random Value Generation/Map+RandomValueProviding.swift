//
//  Map+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import RandomDataGeneration

extension Map: RandomValueProviding {

    public static var random: Map {
        return Map(identifier: .random, location: .random)
    }

}
