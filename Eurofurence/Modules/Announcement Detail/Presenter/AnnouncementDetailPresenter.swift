//
//  AnnouncementDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore

struct AnnouncementDetailPresenter: AnnouncementDetailSceneDelegate {

    private let scene: AnnouncementDetailScene
    private let interactor: AnnouncementDetailInteractor
    private let announcement: Announcement.Identifier

    init(scene: AnnouncementDetailScene, interactor: AnnouncementDetailInteractor, announcement: Announcement.Identifier) {
        self.scene = scene
        self.interactor = interactor
        self.announcement = announcement

        scene.setDelegate(self)
        scene.setAnnouncementTitle(.announcement)
    }

    func announcementDetailSceneDidLoad() {
        interactor.makeViewModel(for: announcement, completionHandler: announcementViewModelPrepared)
    }

    private func announcementViewModelPrepared(_ viewModel: AnnouncementViewModel) {
        scene.setAnnouncementContents(viewModel.contents)
        scene.setAnnouncementHeading(viewModel.heading)
        viewModel.imagePNGData.let(scene.setAnnouncementImagePNGData)
    }

}
