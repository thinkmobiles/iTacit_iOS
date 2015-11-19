//
//  RecipientsCountModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class RecipientsCountModel: BaseModel {

	override var path: String {
		return "/mobile/1.0/employee/advanced/summary"
	}

	var count = 0

	func load(recipients: [NewMessageModel.Recipient], completion: CompletionHandler? = nil) {
		count = 0
		let JSONValues = recipients.map { try! $0.JSONValue() }
		performRequest({ [unowned self] (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: ["mixedList": JSONValues])
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			guard let stronSelf = self else {
				return
			}
			stronSelf.defaultSuccessHandler(data, request: request, response: response, completion: nil)
			completion?(success: true)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

}

// MARK: - KeyValueCodable

extension RecipientsCountModel: KeyValueCodable {

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "count": count <<- value
			default: break
		}
	}

}

// MARK: - Mappable

extension RecipientsCountModel: Mappable {

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "count", JSONKey: "totalRecipients")]
	}

}
