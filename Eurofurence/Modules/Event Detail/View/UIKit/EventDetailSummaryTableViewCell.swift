import UIKit

class EventDetailSummaryTableViewCell: UITableViewCell, EventSummaryComponent {

    // MARK: IBOutlets

    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventSubtitleLabel: UILabel!
    @IBOutlet private weak var eventAbstractLabel: UILabel!
    @IBOutlet private weak var eventTimesLabel: UILabel!
    @IBOutlet private weak var eventLocationLabel: UILabel!
    @IBOutlet private weak var eventTrackLabel: UILabel!
    @IBOutlet private weak var eventHostsLabel: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        accessibilityElements = [eventTrackLabel as Any,
                                 eventTitleLabel as Any,
                                 eventTimesLabel as Any,
                                 eventLocationLabel as Any,
                                 eventHostsLabel as Any,
                                 eventAbstractLabel as Any]
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return super.awakeAfter(using: aDecoder)
    }

    // MARK: EventSummaryComponent

    func setEventTitle(_ title: String) {
        // Comment
        eventTitleLabel.text = "Not localized"
        eventTitleLabel.text = title
    }

    func setEventSubtitle(_ subtitle: String) {
        eventSubtitleLabel.text = subtitle
    }

    func setEventAbstract(_ abstract: NSAttributedString) {
        eventAbstractLabel.attributedText = abstract
    }

    func setEventStartEndTime(_ startEndTime: String) {
        eventTimesLabel.text = startEndTime
    }

    func setEventLocation(_ location: String) {
        eventLocationLabel.text = location
    }

    func setTrackName(_ trackName: String) {
        eventTrackLabel.text = trackName
    }

    func setEventHosts(_ eventHosts: String) {
        eventHostsLabel.text = eventHosts
    }

}
