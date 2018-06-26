//
//  FakeMapsViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeMapsViewModel: MapsViewModel {
    
    var numberOfMaps: Int {
        return maps.count
    }
    
    var maps: [MapViewModel2] = .random
    
    func mapViewModel(at index: Int) -> MapViewModel2 {
        return maps[index]
    }
    
}
