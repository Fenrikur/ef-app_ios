import ComponentBase
import EurofurenceModel
import Foundation.NSAttributedString

public struct DefaultAnnouncementDetailViewModelFactory: AnnouncementDetailViewModelFactory {

    private let announcementsService: AnnouncementsService
    private let markdownRenderer: MarkdownRenderer
    
    public init(
        announcementsService: AnnouncementsService,
        markdownRenderer: MarkdownRenderer
    ) {
        self.announcementsService = announcementsService
        self.markdownRenderer = markdownRenderer
    }

    public func makeViewModel(
        for identifier: AnnouncementIdentifier,
        completionHandler: @escaping (AnnouncementDetailViewModel) -> Void
    ) {
        if let announcement = announcementsService.fetchAnnouncement(identifier: identifier) {
            announcement.fetchAnnouncementImagePNGData { (imageData) in
                let contents = self.markdownRenderer.render(announcement.content)
                let viewModel = AnnouncementDetailViewModel(
                    heading: announcement.title,
                    contents: contents,
                    imagePNGData: imageData
                )
                
                completionHandler(viewModel)
            }
        } else {
            let invalidAnnouncementViewModel = AnnouncementDetailViewModel(
                heading: .invalidAnnouncementAlertTitle,
                contents: markdownRenderer.render(.invalidAnnouncementAlertMessage),
                imagePNGData: nil
            )
            
            completionHandler(invalidAnnouncementViewModel)
        }
    }

}
