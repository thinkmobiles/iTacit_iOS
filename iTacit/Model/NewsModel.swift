//
//  NewsModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class NewsModel: BaseModel, Mappable {

	var articleId = ""
	var headline = ""
	var summary = ""
	var endDate: NSDate? // "2016-09-09",
	var startDate: NSDate?
	var authorName = ""
	var categoryName = ""
	var categoryId = ""
	var headlineImageURL: NSURL?

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
			default: break
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "articleId"),
			PropertyDescriptor(propertyName: "headline"),
			PropertyDescriptor(propertyName: "summary"),
			PropertyDescriptor(propertyName: "articleId"),
			PropertyDescriptor(propertyName: "authorName"),
			PropertyDescriptor(propertyName: "categoryName"),
			PropertyDescriptor(propertyName: "categoryId"),
			PropertyDescriptor(propertyName: "headlineImageURL", JSONKey: "headlineImageUrl"),
			TransformablePropertyDescriptor(propertyName: "endDate", valueTransformer: DateValueTransformer.self),
			TransformablePropertyDescriptor(propertyName: "startDate", valueTransformer: DateValueTransformer.self)]
	}

}

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
