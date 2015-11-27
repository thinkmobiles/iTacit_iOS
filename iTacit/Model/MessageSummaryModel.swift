//
//  MessageSummaryModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/27/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class MessageSummaryModel: BaseModel {

	override var path: String {
		return "/mobile/1.0/messaging/filterSummary"
	}

	private var all = SummaryItem()
	private var act = SummaryItem()
	private var waiting = SummaryItem()
	private var inbox = SummaryItem()
	private var sent = SummaryItem()
	private var archive = SummaryItem()

	var count: Int {
		return 6
	}

	subscript(index: Int) -> (category: MessageCategory, count: Int)? {
		switch index {
			case 0: return (category: MessageCategory.All, count: all.count)
			case 1: return (category: MessageCategory.ActOn, count: act.count)
			case 2: return (category: MessageCategory.Waiting, count: waiting.count)
			case 3: return (category: MessageCategory.ToMe, count: inbox.count)
			case 4: return (category: MessageCategory.FromMe, count: sent.count)
			case 5: return (category: MessageCategory.Archive, count: archive.count)
			default: return nil
		}
	}

	func load(completion: CompletionHandler? = nil) {
		performRequest({ [unowned self] (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: [String: AnyObject]())
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

}

extension MessageSummaryModel {

	struct SummaryItem: Mappable {

		var count = 0
		var readRequired = false

		init() {}

		mutating func setValue<T>(value: T, forKey key: String) throws {
			try validateKey(key, typeOfValue: T.self)
			switch key {
				case "count": count <<- value
				case "readRequired": readRequired <<- value
				default: return
			}
		}

		static var mapping: [PropertyDescriptor] {
			return [PropertyDescriptor(propertyName: "count", JSONKey: "messageCount"),
					PropertyDescriptor(propertyName: "readRequired")]
		}

	}

}

// MARK: - KeyValueCodable

extension MessageSummaryModel: KeyValueCodable {

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "all": all <<- value
			case "act": act <<- value
			case "waiting": waiting <<- value
			case "inbox": inbox <<- value
			case "sent": sent <<- value
			case "archive": archive <<- value
			default: break
		}
	}

}

// MARK: - Mappable

extension MessageSummaryModel: Mappable {

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "all", JSONKey: "ALL"),
				PropertyDescriptor(propertyName: "act", JSONKey: "ACT"),
				PropertyDescriptor(propertyName: "waiting", JSONKey: "WAITING"),
				PropertyDescriptor(propertyName: "inbox", JSONKey: "INBOX"),
				PropertyDescriptor(propertyName: "sent", JSONKey: "SENT"),
				PropertyDescriptor(propertyName: "archive", JSONKey: "ARCHIVE")]
	}

}
