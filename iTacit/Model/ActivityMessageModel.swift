//
//  ActivityMessageModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class ActivityMessageModel: MessageModel {

	var senderFullName = ""
	var senderImageURL: NSURL?

	var subjectAttributedString: NSAttributedString {
		let attributes = [NSFontAttributeName: UIFont.openSansRegular(13), NSForegroundColorAttributeName: AppColors.darkGray]
		return NSAttributedString(string: subject, attributes: attributes)
	}

	// MARK: - KeyValueCodable

	override func setValue<T>(value: T, forKey key: String) throws {
		try super.setValue(value, forKey: key)
		switch key {
			case "senderFullName": senderFullName <<- value
			case "senderImageURL": senderImageURL <<- value
			default: break
		}
	}

	// MARK: - Mappable

	override class var mapping: [PropertyDescriptor] {
		return super.mapping + [PropertyDescriptor(propertyName: "senderFullName", JSONKey: "senderNameFull"),
								PropertyDescriptor(propertyName: "senderImageURL", JSONKey: "senderImageUrl")]
	}

}
