//
//  DashboardTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class DashboardTableViewCell: RemoteImageTableViewCell {

	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!

	func configureWithFullName(fullName: String, subject: NSAttributedString, body: NSAttributedString, timeString: String, imageURL: NSURL?) {
		fullNameLabel.text = fullName
		subjectLabel.attributedText = subject
		bodyLabel.attributedText = body
		timeLabel.text = timeString
	}

}
