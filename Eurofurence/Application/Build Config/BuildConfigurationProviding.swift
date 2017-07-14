//
//  BuildConfigurationProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

enum BuildConfiguration {
    case debug
    case release
}

protocol BuildConfigurationProviding {

    var configuration: BuildConfiguration { get }

}
