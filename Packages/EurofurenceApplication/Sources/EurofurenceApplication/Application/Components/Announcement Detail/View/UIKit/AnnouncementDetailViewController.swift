import UIKit

class AnnouncementDetailViewController: UITableViewController, AnnouncementDetailScene {

    // MARK: IBOutlets

    @IBOutlet private weak var announcementHeadingLabel: UILabel!
    @IBOutlet private weak var announcementContentsTextView: UITextView!
    @IBOutlet private weak var announcementImageView: UIImageView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        announcementContentsTextView.textContainer.lineFragmentPadding = 0
        delegate?.announcementDetailSceneDidLoad()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: AnnouncementDetailScene

    private var delegate: AnnouncementDetailSceneDelegate?
    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setAnnouncementTitle(_ title: String) {
        super.title = title
    }

    func setAnnouncementHeading(_ heading: String) {
        announcementHeadingLabel.text = heading
    }

    func setAnnouncementContents(_ contents: NSAttributedString) {
        announcementContentsTextView.attributedText = contents
    }

    func setAnnouncementImagePNGData(_ pngData: Data) {
        announcementImageView.image = UIImage(data: pngData)
    }

}
