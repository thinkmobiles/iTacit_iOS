//
//  NewsModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class NewsModel: BaseModel, Mappable {

	override var path: String {
		return "/mobile/1.0/news/article/%@"
	}

	var articleId = ""
	var headline = ""
	var summary: NSAttributedString?
	var endDate: NSDate? // "2016-09-09",
	var startDate: NSDate?
	var authorName = ""
	var categoryName = ""
	var categoryId = ""
	var headlineImageURL: NSURL?
	var body: NSAttributedString?
    var authorID = ""

	func load(completion: CompletionHandler? = nil) {
		performRequest({ (builder) -> Void in
			builder.path = String(format: self.path, arguments: [self.articleId])
			builder.method = .GET
		}, successHandler: { [weak self] (data, request, response) -> Void in
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

	// MARK: - Mapping

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "articleId": articleId <<- value
			case "headline": headline <<- value
			case "summary": summary <<- value
			case "endDate": endDate <<- value
			case "startDate": startDate <<- value
			case "authorName": authorName <<- value
			case "categoryName": categoryName <<- value
			case "categoryId": categoryId <<- value
			case "headlineImageURL": headlineImageURL <<- value
			case "body": body <<- value
            case "authorID": authorID <<- value
			default: break
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "articleId"),
			PropertyDescriptor(propertyName: "headline"),
			PropertyDescriptor(propertyName: "articleId"),
			PropertyDescriptor(propertyName: "authorName"),
			PropertyDescriptor(propertyName: "categoryName"),
			PropertyDescriptor(propertyName: "categoryId"),
            PropertyDescriptor(propertyName: "authorID"),
			PropertyDescriptor(propertyName: "headlineImageURL", JSONKey: "headlineImageUrl"),
			TransformablePropertyDescriptor(propertyName: "summary", valueTransformer: HTMLToAttributedStringTransformer.self),
			TransformablePropertyDescriptor(propertyName: "endDate", valueTransformer: DateValueTransformer.self),
			TransformablePropertyDescriptor(propertyName: "startDate", valueTransformer: DateValueTransformer.self),
			TransformablePropertyDescriptor(propertyName: "body", valueTransformer: HTMLToAttributedStringTransformer.self)]
	}

}

// MARK: - Value Transformers

class DateValueTransformer: JSONValueTransformer {

	private static let birthDateFormatter: NSDateFormatter = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()

	class func transformFromJSONValue(value: AnyObject) throws -> Any {
		if let stringDate = value as? String  {
			return birthDateFormatter.dateFromString(stringDate)
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

	class func transformToJSONValue(value: Any) throws -> AnyObject {
		if let date = value as? NSDate {
			return birthDateFormatter.stringFromDate(date)
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}
	
}

class HTMLToAttributedStringTransformer: JSONValueTransformer {

	class func transformFromJSONValue(value: AnyObject) throws -> Any {
		if let HTMLStringData = (value as? String)?.dataUsingEncoding(NSUTF8StringEncoding) {
			let options: [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
				NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding]
			return try? NSAttributedString(data: HTMLStringData, options: options, documentAttributes: nil)
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

	class func transformToJSONValue(value: Any) throws -> AnyObject {
		return "\(value)"
	}

}
