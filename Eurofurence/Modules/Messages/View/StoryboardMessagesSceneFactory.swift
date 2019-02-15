//
//  StoryboardMessagesSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

struct StoryboardMessagesSceneFactory: MessagesSceneFactory {

    private let storyboard = UIStoryboard(name: "Messages", bundle: .main)

    func makeMessagesScene() -> UIViewController & MessagesScene {
        return storyboard.instantiate(MessagesViewController.self)
    }

}