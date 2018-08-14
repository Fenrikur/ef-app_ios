//
//  ScheduleDayCollectionViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ScheduleDayCollectionViewCell: UICollectionViewCell, ScheduleDayComponent {

    @IBOutlet weak var selectedDecorationView: UIView!
    @IBOutlet weak var dayTitleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            updateSelectionStateAppearence()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateSelectionStateAppearence()
    }

    private func updateSelectionStateAppearence() {
        selectedDecorationView.alpha = isSelected ? 1 : 0

        let font: UIFont = {
            let size = UIFont.preferredFont(forTextStyle: .footnote).pointSize
            return isSelected ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }()

        dayTitleLabel.font = font
    }

    func setDayTitle(_ title: String) {
        dayTitleLabel.text = title
        dayTitleLabel.accessibilityHint = .restrictEventsAccessibilityHint(date: title)
    }

}
