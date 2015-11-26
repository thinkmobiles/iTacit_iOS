//
//  ActivityFeedTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ActivityFeedTableViewCell: RemoteImageTableViewCell {

	static let reuseIdentifier = "ActivityFeedTableViewCell"

	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!

	func configureWithActivityFeedItem(feedItem: ActivityFeedItemModel) {
		fullNameLabel.text = feedItem.senderFullName
		subjectLabel.attributedText = feedItem.subjectAttributedString
		bodyLabel.attributedText = feedItem.body
		timeLabel.text = feedItem.timeString
		setImageWithURL(feedItem.senderImageURL)
	}

}
