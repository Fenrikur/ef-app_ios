//
//  CapturingDealerComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealerComponent: DealerComponent {
    
    private(set) var capturedDealerTitle: String?
    func setDealerTitle(_ title: String) {
        capturedDealerTitle = title
    }
    
}
