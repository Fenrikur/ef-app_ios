//
//  CapturingTutorialModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore

class CapturingTutorialModuleDelegate: TutorialModuleDelegate {
    
    private(set) var wasToldTutorialFinished = false
    func tutorialModuleDidFinishPresentingTutorial() {
        wasToldTutorialFinished = true
    }
    
}
