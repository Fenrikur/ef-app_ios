//
//  MessageTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit

class MessageTableViewCell: UITableViewCell, MessageItemScene {

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter
    }()

    @IBOutlet weak var messageAuthorLabel: UILabel!
    @IBOutlet weak var messageSubjectLabel: UILabel!
    @IBOutlet weak var messageReceivedDateLabel: UILabel!
    @IBOutlet weak var messageSynopsisLabel: UILabel!
    @IBOutlet weak var unreadMessageIndicator: UnreadMessageIndicator!

    override func prepareForReuse() {
        super.prepareForReuse()

        accessibilityLabel = nil
        messageAuthorLabel.text = nil
        messageSubjectLabel.text = nil
        messageReceivedDateLabel.text = nil
        messageSynopsisLabel.text = nil
    }

    func setAuthor(_ author: String) {
        messageAuthorLabel.text = author
    }

    func setSubject(_ subject: String) {
        messageSubjectLabel.text = subject
    }

    func setContents(_ contents: String) {
        messageSynopsisLabel.text = contents
    }

    func setReceivedDateTime(_ dateTime: String) {
        messageReceivedDateLabel.text = dateTime
    }

    func showUnreadIndicator() {
        unreadMessageIndicator.isHidden = false
    }

    func hideUnreadIndicator() {
        unreadMessageIndicator.isHidden = true
    }

}
