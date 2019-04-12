import UIKit

class AnnouncementTableViewCell: UITableViewCell, AnnouncementComponent {

    // MARK: IBOutlets

    @IBOutlet weak var announcementReceivedDateTimeLabel: UILabel!
    @IBOutlet weak var announcementTitleLabel: UILabel!
    @IBOutlet weak var announcementDescriptionLabel: UILabel!
    @IBOutlet weak var unreadIndicatorView: UIView!

    // MARK: AnnouncementComponent

    func setAnnouncementTitle(_ title: String) {
        announcementTitleLabel.text = title
    }

    func setAnnouncementDetail(_ detail: NSAttributedString) {
        announcementDescriptionLabel.attributedText = detail
    }

    func setAnnouncementReceivedDateTime(_ receivedDateTime: String) {
        announcementReceivedDateTimeLabel.text = receivedDateTime
    }

    func hideUnreadIndicator() {
        unreadIndicatorView.isHidden = true
    }

    func showUnreadIndicator() {
        unreadIndicatorView.isHidden = false
    }

}
