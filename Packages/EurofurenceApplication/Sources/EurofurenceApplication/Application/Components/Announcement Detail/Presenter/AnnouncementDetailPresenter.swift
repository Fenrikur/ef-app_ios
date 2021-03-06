import EurofurenceModel

class AnnouncementDetailPresenter: AnnouncementDetailSceneDelegate {

    private weak var scene: AnnouncementDetailScene?
    private let announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory
    private let announcement: AnnouncementIdentifier

    init(
        scene: AnnouncementDetailScene,
        announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory,
        announcement: AnnouncementIdentifier
    ) {
        self.scene = scene
        self.announcementDetailViewModelFactory = announcementDetailViewModelFactory
        self.announcement = announcement

        scene.setDelegate(self)
        scene.setAnnouncementTitle(.announcement)
    }

    func announcementDetailSceneDidLoad() {
        announcementDetailViewModelFactory.makeViewModel(
            for: announcement,
            completionHandler: announcementViewModelPrepared
        )
    }

    private func announcementViewModelPrepared(_ viewModel: AnnouncementDetailViewModel) {
        scene?.setAnnouncementContents(viewModel.contents)
        scene?.setAnnouncementHeading(viewModel.heading)
        
        if let imageData = viewModel.imagePNGData {
            scene?.setAnnouncementImagePNGData(imageData)
        }
    }

}
