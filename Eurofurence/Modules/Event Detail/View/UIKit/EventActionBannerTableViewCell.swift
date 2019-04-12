import UIKit

class EventActionBannerTableViewCell: UITableViewCell, EventActionBannerComponent {
    
    @IBOutlet private weak var bannerActionButton: UIButton!
    
    func setActionTitle(_ title: String) {
        bannerActionButton.setTitle(title, for: .normal)
    }
    
    private var handler: (() -> Void)?
    func setSelectionHandler(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    @IBAction private func performBannerAction() {
        handler?()
    }
    
}
