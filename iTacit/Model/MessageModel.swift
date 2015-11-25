//
// Created by Sauron Black on 11/12/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import Foundation

class MessageModel: BaseMessageModel {

	var id = ""
	var parentMessageId = ""
	var replyCount = 0
	var sendDate: NSDate?
	var sender: UserProfileModel?
	var hasRead = false

	override var readRequirementType: ReadRequirementType {
		get {
			switch (super.readRequirementType, hasRead) {
				case (.RequiredTo(let date), false): return .RequiredTo(date: date)
				default: return .NotRequired
			}
		}
		set {
			super.readRequirementType = newValue
		}
	}

	func archive(completion: CompletionHandler? = nil) {
		performRequest({ [unowned self] (builder) -> Void in
			builder.path = "/mobile/1.0/messaging/archive/\(self.id)"
			builder.method = .PUT
			builder.contentType = .ApplicationJSON
		}, successHandler: { (data, request, response) -> Void in
			completion?(success: true)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}
    
    func confirm(completion: CompletionHandler? = nil) {
        performRequest({ [unowned self] (builder) -> Void in
            builder.path = "/mobile/1.0/messaging/readConfirm/\(self.id)"
            builder.method = .PUT
            builder.contentType = .ApplicationJSON
            }, successHandler: { (data, request, response) -> Void in
                completion?(success: true)
            }) { (error, request, response) -> Void in
                completion?(success: false)
        }
    }

	// MARK: - KeyValueCodable

	override func setValue<T>(value: T, forKey key: String) throws {
		try super.setValue(value, forKey: key)
		switch key {
			case "id": id <<- value
			case "parentMessageId": parentMessageId <<- value
			case "replyCount": replyCount <<- value
			case "sender": sender <<- value
			case "sendDate": sendDate <<- value
			case "hasRead": hasRead <<- value
			default: break
		}
	}

	// MARK: - Mappable

	override class var mapping: [PropertyDescriptor] {
		return super.mapping + [PropertyDescriptor(propertyName: "id"),
			PropertyDescriptor(propertyName: "parentMessageId"),
			PropertyDescriptor(propertyName: "replyCount", JSONKey: "replyCountNew"),
			PropertyDescriptor(propertyName: "sendDate", JSONKey: "sendDateTime"),
			PropertyDescriptor(propertyName: "sender"),
			PropertyDescriptor(propertyName: "hasRead", JSONKey: "markedAsRead")]
	}

}
