//
//  RootModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol RootModuleFactory {

    func makeRootModule(_ delegate: RootModuleDelegate)

}

protocol RootModuleDelegate {

    func userNeedsToWitnessTutorial()
    func storeShouldBePreloaded()

}
