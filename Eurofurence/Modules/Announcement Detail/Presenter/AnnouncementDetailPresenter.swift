import EurofurenceModel

struct AnnouncementDetailPresenter: AnnouncementDetailSceneDelegate {

    private let scene: AnnouncementDetailScene
    private let interactor: AnnouncementDetailInteractor
    private let announcement: AnnouncementIdentifier

    init(scene: AnnouncementDetailScene, interactor: AnnouncementDetailInteractor, announcement: AnnouncementIdentifier) {
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
