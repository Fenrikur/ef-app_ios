//
//  StubDealerDetailModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import UIKit

class StubDealerDetailModuleProviding: DealerDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: Dealer.Identifier?
    func makeDealerDetailModule(for dealer: Dealer.Identifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }

}
