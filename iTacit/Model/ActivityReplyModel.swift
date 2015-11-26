//
//  ActivityReplyModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ActivityReplyModel: ReplyModel {

	var subject = ""
	var senderFullName = ""
	var senderImageURL: NSURL?

	var subjectAttributedString: NSAttributedString {
		guard !subject.isEmpty else {
			return NSAttributedString(string: "")
		}

		let attributes = [NSFontAttributeName: UIFont.openSansRegular(13), NSForegroundColorAttributeName: AppColors.darkGray]
		let attributedString = NSMutableAttributedString(string: "RE: " + subject, attributes: attributes)
		attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexColor: 0x7D7D83), range: NSMakeRange(0, 3))
		return attributedString
	}

	var timeString: String {
		return sendDateTime?.timeAgoStringRepresentation() ?? ""
	}

	// MARK: - KeyValueCodable

	override func setValue<T>(value: T, forKey key: String) throws {
		try super.setValue(value, forKey: key)
		switch key {
			case "subject": subject <<- value
			case "senderFullName": senderFullName <<- value
			case "senderImageURL": senderImageURL <<- value
			default: break
		}
	}

	// MARK: - Mappable

	override class var mapping: [PropertyDescriptor] {
		return super.mapping + [PropertyDescriptor(propertyName: "subject"),
			PropertyDescriptor(propertyName: "senderFullName", JSONKey: "senderNameFull"),
			PropertyDescriptor(propertyName: "senderImageURL", JSONKey: "senderImageUrl")]
	}

}

extension ActivityReplyModel: ActivityFeedItemModel { }
