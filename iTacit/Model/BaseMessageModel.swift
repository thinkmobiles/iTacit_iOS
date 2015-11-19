//
//  BaseMessageModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class BaseMessageModel: BaseModel, Mappable {

	override var path: String {
		return "/mobile/1.0/messaging/message"
	}

	var subject = ""
	var body: NSAttributedString?
	private var readRequiredDate: NSDate?

	var readRequirementType: ReadRequirementType {
		get {
			if let date = readRequiredDate {
				return .RequiredTo(date: date)
			} else {
				return .NotRequired
			}
		}
		set {
			switch newValue {
				case .NotRequired:
					readRequiredDate = nil
				case .RequiredTo(let date):
					readRequiredDate = date
			}
		}
	}

	// MARK: - KeyValueCodable

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "subject": subject <<- value
			case "body": body <<- value
			case "readRequiredDate": readRequiredDate <<- value
			default: break
		}
	}

	// MARK: - Mappable

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "subject"),
			PropertyDescriptor(propertyName: "readRequiredDate"),
			TransformablePropertyDescriptor(propertyName: "body", valueTransformer: HTMLToAttributedStringTransformer.self)]
	}

}

extension BaseMessageModel {

	enum ReadRequirementType {
		case NotRequired
		case RequiredTo(date: NSDate)
	}

}
