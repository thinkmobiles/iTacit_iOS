//
//  MessageTableViewCell.swift
//  iTacit
//
//  Created by Sauron Black on 11/13/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

	private struct Constants {
		static let bodyLabelBottomSpaceDefault = CGFloat(10)
		static let bodyLabelBottomSpaceExtended = CGFloat(35)
		static let defaultInteritemSpace = CGFloat(8)
		static let dateLabelTrailingSpace = CGFloat(11)
		static let bodyLabelLineHeightMultiple = CGFloat(0.85)
	}

	static let readDateFormatter: NSDateFormatter = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMM.dd,yyyy"
		return dateFormatter
	}()

	static let reuseIdentifier = "MessageTableViewCell"

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var userStatusLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var badgeButton: UIButton!
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	@IBOutlet weak var readRequriemantButton: UIButton!
	@IBOutlet weak var bodyLabelBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var dateLabelTrailingConstraint: NSLayoutConstraint!

	var imageDownloadTask: NSURLSessionTask?

	var badgeValue: Int {
		get {
			return ((badgeButton.titleLabel?.text ?? "") as NSString).integerValue
		}
		set {
			badgeButton.setTitle("\(newValue)", forState: .Normal)
			if newValue == 0 {
				badgeButton.hidden = true
				dateLabelTrailingConstraint.constant = Constants.dateLabelTrailingSpace
			} else {
				badgeButton.hidden = false
				dateLabelTrailingConstraint.constant = Constants.dateLabelTrailingSpace + Constants.defaultInteritemSpace + CGRectGetWidth(badgeButton.bounds)
			}
		}
	}

	// MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsetsZero
    }

	// MARK: - Public

	func configureWithMessage(message: MessageModel) {
		if let sender = message.sender {
			setUserImageWithURL(sender.imageURL)
			fullNameLabel.text = sender.fullName
			userStatusLabel.text = sender.status
		}
		dateLabel.text = message.sendDate?.timeAgoStringRepresentation()
		badgeValue = message.replyCount
		subjectLabel.text = message.subject
		if let body = message.body {
			setMessageBody(body)
		}
		switch message.readRequirementType {
			case .NotRequired:
				readRequriemantButton.hidden = true
				bodyLabelBottomConstraint.constant = Constants.bodyLabelBottomSpaceDefault
			case .RequiredTo(let date):
				let readDateString = LocalizedString("This must be read by ") + MessageTableViewCell.readDateFormatter.stringFromDate(date)
				readRequriemantButton.setTitle(readDateString, forState: .Normal)
				readRequriemantButton.hidden = false
				bodyLabelBottomConstraint.constant = Constants.bodyLabelBottomSpaceExtended
		}
	}

	func setMessageBody(body: NSAttributedString) {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineHeightMultiple = Constants.bodyLabelLineHeightMultiple
		let mutableBody = NSMutableAttributedString(attributedString: body)
		mutableBody.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSMakeRange(0, (body.string as NSString).length))
		bodyLabel.attributedText = mutableBody
	}

	func setUserImageWithURL(imageURL: NSURL?) {
		imageDownloadTask?.cancel()
		if let imageURL = imageURL {
			imageDownloadTask = ImageCacheManager.sharedInstance.imageForURL(imageURL, completion: { [weak self] (image) -> Void in
				self?.userImageView.image = image
			})
		} else {
			userImageView.image = nil
		}
	}

}
