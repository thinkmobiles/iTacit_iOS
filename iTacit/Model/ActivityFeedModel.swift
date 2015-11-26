//
//  ActivityFeedModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

protocol ActivityFeedItemModel {

	var senderFullName: String { get set }
	var senderImageURL: NSURL? { get set }
	var body: NSAttributedString? { get set }
	var subjectAttributedString: NSAttributedString { get }
	var timeString: String { get }

}

class ActivityFeedModel: BaseModel {

	override var path: String {
		return "/mobile/1.0/system/activityFeed"
	}

	private var replies = [ActivityReplyModel]()
	private var messages = [ActivityMessageModel]()

	var count: Int {
		return replies.count + messages.count
	}

	subscript(index: Int) -> ActivityFeedItemModel {
		if index < replies.count {
			return replies[index]
		} else {
			return messages[index - replies.count]
		}
	}

	func load(completion: CompletionHandler? = nil) {
		performRequest({ (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: ["fields": "inbox|replies"])
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

}

extension ActivityFeedModel: KeyValueCodable {

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "replies": replies <<- value
			case "messages": messages <<- value
			default: break
		}
	}

}

extension ActivityFeedModel: Mappable {

	class var mapping: [PropertyDescriptor] {
		return [TransformablePropertyDescriptor(propertyName: "replies", JSONKey: "responseRows", valueTransformer: ActivityFeedRepliesTransformer.self),
				TransformablePropertyDescriptor(propertyName: "messages", JSONKey: "responseRows", valueTransformer: ActivityFeedMessagesTransformer.self)]
	}

}

class ActivityFeedRepliesTransformer: JSONValueTransformer {

	class func transformFromJSONValue(value: AnyObject) throws -> Any {
		if var JSON = (value as? [[String: AnyObject]])?.first?["replies"] as? [String: AnyObject]  {
			if let repliesJSONArray = JSON["responseRows"] as? [[String: AnyObject]] {
				let replies: [ActivityReplyModel] = try JSONMapper.map(repliesJSONArray)
				return replies
			}
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

	class func transformToJSONValue(value: Any) throws -> AnyObject {
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}
	
}

class ActivityFeedMessagesTransformer: JSONValueTransformer {

	class func transformFromJSONValue(value: AnyObject) throws -> Any {
		if var JSON = (value as? [[String: AnyObject]])?.first?["inbox"] as? [String: AnyObject]  {
			if let messagesJSONArray = JSON["responseRows"] as? [[String: AnyObject]] {
				let replies: [ActivityMessageModel] = try JSONMapper.map(messagesJSONArray)
				return replies
			}
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

	class func transformToJSONValue(value: Any) throws -> AnyObject {
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

}
