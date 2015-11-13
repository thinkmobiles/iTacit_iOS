//
// Created by Sauron Black on 11/12/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import Foundation

class MessageModel: BaseModel {

	override var path: String {
		return "/mobile/1.0/messaging/message"
	}

	var id = ""
	var parentMessageId = ""
	var replyCount = 0
	var subject = ""
	var body: NSAttributedString?
	var sendDate: NSDate?
	var sender: UserProfileModel?

	private var readRequired = false
	private var readRequiredDate: NSDate?

	var readRequirementType: ReadRequirementType {
		get {
			if let date = readRequiredDate where readRequired {
				return .RequiredTo(date: date)
			} else {
				return .NotRequired
			}
		}
		set {
			switch newValue {
				case .NotRequired:
					readRequired = false
					readRequiredDate = nil
				case .RequiredTo(let date):
					readRequired = true
					readRequiredDate = date
			}
		}
	}

}

extension MessageModel {

	enum ReadRequirementType {
		case NotRequired
		case RequiredTo(date: NSDate)
	}

}

// MARK: - KeyValueCodable

extension MessageModel: KeyValueCodable {

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "id": id <<- value
			case "parentMessageId": parentMessageId <<- value
			case "replyCount": replyCount <<- value
			case "subject": subject <<- value
			case "body": body <<- value
			case "sender": sender <<- value
			case "sendDate": sendDate <<- value
			case "readRequired": readRequired <<- value
			case "readRequiredDate": readRequiredDate <<- value
			default: break
		}
	}

}

// MARK: - Mappable

extension MessageModel: Mappable {

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "id"),
				PropertyDescriptor(propertyName: "parentMessageId"),
				PropertyDescriptor(propertyName: "replyCount", JSONKey: "replyCountNew"),
				PropertyDescriptor(propertyName: "subject"),
				PropertyDescriptor(propertyName: "sendDate", JSONKey: "sendDateTime"),
				PropertyDescriptor(propertyName: "readRequired", JSONKey: "readRequiredYn"),
				PropertyDescriptor(propertyName: "readRequiredDate"),
				TransformablePropertyDescriptor(propertyName: "body", valueTransformer: HTMLToAttributedStringTransformer.self),
				TransformablePropertyDescriptor(propertyName: "sender", valueTransformer: SenderTransformer.self)]
	}

}

extension MessageModel {

	class SenderTransformer: JSONValueTransformer {

		class func transformFromJSONValue(value: AnyObject) throws -> Any {
			if let senderJSON = value as? [String: AnyObject] {
				let usersList: UserProfileListModel = try JSONMapper.map(senderJSON)
				return usersList.objects.first
			}
			throw ValueTransformerError.FailedToTransformValue(value: value)
		}

		class func transformToJSONValue(value: Any) throws -> AnyObject {
			return "\(value)"
		}

	}

}
