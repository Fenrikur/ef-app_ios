//
//  EventDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class EventDetailModuleBuilder {

    private var sceneFactory: EventDetailSceneFactory
    private var interactor: EventDetailInteractor

    init() {
        struct DummyEventDetailInteractor: EventDetailInteractor {
            func makeViewModel(for event: Event2, completionHandler: @escaping (EventDetailViewModel) -> Void) {
                struct DummyEventDetailViewModel: EventDetailViewModel {
                    var title: String = "Test Title"
                    var eventStartTime: String = "Test Start Time"
                    var location: String = "Test Location"
                    var trackName: String = "Test Track Name"
                    var eventHosts: String = "Test Hosts"
                }

                completionHandler(DummyEventDetailViewModel())
            }
        }

        sceneFactory = StoryboardEventDetailSceneFactory()
        interactor = DummyEventDetailInteractor()
    }

    @discardableResult
    func with(_ sceneFactory: EventDetailSceneFactory) -> EventDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: EventDetailInteractor) -> EventDetailModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> EventDetailModuleProviding {
        return EventDetailModule(sceneFactory: sceneFactory, interactor: interactor)
    }

}
