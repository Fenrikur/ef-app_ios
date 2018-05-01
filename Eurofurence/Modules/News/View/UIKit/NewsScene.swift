//
//  NewsScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol NewsSceneDelegate {

    func newsSceneWillAppear()
    func newsSceneDidSelectComponent(at indexPath: IndexPath)

}

protocol NewsScene: class {

    var delegate: NewsSceneDelegate? { get set }

    func showNewsTitle(_ title: String)
    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder)

}
