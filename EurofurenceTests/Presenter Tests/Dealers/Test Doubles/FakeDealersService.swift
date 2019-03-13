//
//  FakeDealersService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class FakeDealersService: DealersService {
    
    let index: FakeDealersIndex

    init(index: FakeDealersIndex = FakeDealersIndex()) {
        self.index = index
    }
    
    private var stubbedDealers = [Dealer]()
    func fetchDealer(for identifier: DealerIdentifier) -> Dealer? {
        return stubbedDealers.first(where: { $0.identifier == identifier })
    }

    func makeDealersIndex() -> DealersIndex {
        return index
    }

}

extension FakeDealersService {
    
    func add(_ dealer: Dealer) {
        stubbedDealers.append(dealer)
    }

}
