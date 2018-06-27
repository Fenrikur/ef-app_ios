//
//  MapDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapDetailScene {

    func setDelegate(_ delegate: MapDetailSceneDelegate)
    func setMapImagePNGData(_ data: Data)
    func setMapTitle(_ title: String)

}

protocol MapDetailSceneDelegate {

    func mapDetailSceneDidLoad()

}
