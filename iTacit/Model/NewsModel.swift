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
		return "/mobile/1.0/news/article"
	}

	var id = ""
	var headline = ""
	var summary: NSAttributedString?
	var endDate: NSDate?
	var startDate: NSDate?
	var authorName = ""
	var categoryName = ""
	var categoryId = ""
	var headlineImageURL: NSURL?
	var body: NSAttributedString?
    var authorId = ""

	func load(completion: CompletionHandler? = nil) {
		performRequest({ (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: ["id": self.id, "fields": "DEFAULT|body"])
			builder.contentType = .ApplicationJSON
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
			case "id": id <<- value
			case "headline": headline <<- value
			case "summary": summary <<- value
			case "endDate": endDate <<- value
			case "startDate": startDate <<- value
			case "authorName": authorName <<- value
			case "categoryName": categoryName <<- value
			case "categoryId": categoryId <<- value
			case "headlineImageURL": headlineImageURL <<- value
			case "body": body <<- value
            case "authorId": authorId <<- value
			default: break
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "id"),
			PropertyDescriptor(propertyName: "headline"),
			PropertyDescriptor(propertyName: "authorName"),
			PropertyDescriptor(propertyName: "categoryName"),
			PropertyDescriptor(propertyName: "categoryId"),
            PropertyDescriptor(propertyName: "authorId"),
			PropertyDescriptor(propertyName: "headlineImageURL", JSONKey: "headlineImageUrl"),
			TransformablePropertyDescriptor(propertyName: "summary", valueTransformer: HTMLToAttributedStringTransformer.self),
			TransformablePropertyDescriptor(propertyName: "endDate", valueTransformer: DateValueTransformer.self),
			TransformablePropertyDescriptor(propertyName: "startDate", valueTransformer: DateValueTransformer.self),
			TransformablePropertyDescriptor(propertyName: "body", valueTransformer: HTMLToAttributedStringTransformer.self)]
	}

}

// MARK: - Value Transformers

class DateValueTransformer: JSONValueTransformer {

	static let dateFormatter: NSDateFormatter = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()

	class func transformFromJSONValue(value: AnyObject) throws -> Any {
		if let stringDate = value as? String  {
			return dateFormatter.dateFromString(stringDate)
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

	class func transformToJSONValue(value: Any) throws -> AnyObject {
		if let date = value as? NSDate {
			return dateFormatter.stringFromDate(date)
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}
	
}

class HTMLToAttributedStringTransformer: JSONValueTransformer {

	class func transformFromJSONValue(value: AnyObject) throws -> Any {
		if var HTMLString = value as? String {
			HTMLString += "<style>body{font-family: OpenSans;}</style>"
			if let HTMLStringData = HTMLString.dataUsingEncoding(NSUTF8StringEncoding) {
				let options: [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
					NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding]
				return try? NSAttributedString(data: HTMLStringData, options: options, documentAttributes: nil)
			}
		}
		throw ValueTransformerError.FailedToTransformValue(value: value)
	}

	class func transformToJSONValue(value: Any) throws -> AnyObject {
		return (value as? NSAttributedString)?.string ?? ""
	}

}

class YnStringToBoolTransformer: JSONValueTransformer {
    class func transformFromJSONValue(value: AnyObject) throws -> Any {
        if let booleanString = value as? String {
            if booleanString == "Y" {
                return true
            } else {
                return false
            }
        }
        throw ValueTransformerError.FailedToTransformValue(value: value)
    }
    
    class func transformToJSONValue(value: Any) throws -> AnyObject {
        if let booleanString = value as? String {
            if booleanString == "Y" {
                return true
            } else {
                return false
            }
        }
        
        throw ValueTransformerError.FailedToTransformValue(value: value)
    }
}
