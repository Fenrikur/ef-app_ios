import UIKit

class NewsUserWidgetTableViewCell: UITableViewCell, UserWidgetComponent {

    // MARK: Properties

    private let standardUserPromptColor = UIColor(white: 0.5, alpha: 1.0)
    private let highlightedUserPromptColor = UIColor.eurofurenceGreen

    // MARK: IBOutlets

    @IBOutlet weak var standardUserPromptView: UIView!
    @IBOutlet weak var highlightedUserPromptView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var detailedPromptLabel: UILabel!

    // MARK: UserWidgetComponent

    func setPrompt(_ prompt: String) {
        promptLabel.text = prompt
    }

    func setDetailedPrompt(_ detailedPrompt: String) {
        detailedPromptLabel.text = detailedPrompt
    }

    func showHighlightedUserPrompt() {
        highlightedUserPromptView.isHidden = false
        detailedPromptLabel.textColor = highlightedUserPromptColor
    }

    func hideHighlightedUserPrompt() {
        highlightedUserPromptView.isHidden = true
    }

    func showStandardUserPrompt() {
        standardUserPromptView.isHidden = false
        detailedPromptLabel.textColor = standardUserPromptColor
    }

    func hideStandardUserPrompt() {
        standardUserPromptView.isHidden = true
    }

}
