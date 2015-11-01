//
//  Extensions.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 10/2/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

extension Int: JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> Int {
		if let number = value as? NSNumber {
			return number.integerValue
		} else if let string = value as? NSString {
			return string.integerValue
		}
		throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: Int.self)
	}

	func JSONValue() throws -> AnyObject {
		return NSNumber(integer: self)
	}
}

extension Double: JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> Double {
		if let number = value as? NSNumber {
			return number.doubleValue
		} else if let string = value as? NSString {
			return string.doubleValue
		}
		throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: Double.self)
	}

	func JSONValue() throws -> AnyObject {
		return NSNumber(double: self)
	}
}

extension String: JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> String {
		if let number = value as? NSNumber {
			return number.stringValue
		} else if let string = value as? String {
			return string
		}
		throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: String.self)
	}

	func JSONValue() throws -> AnyObject {
		return self
	}
}

extension NSDate: JSONValueConvertible {

	class var ISO8601DateFormatter: NSDateFormatter {
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
		return formatter
	}

	class func convertFromJSONValue(value: AnyObject) throws -> Self {
		if let dateString = value as? String, date = ISO8601DateFormatter.dateFromString(dateString) {
			return self.init(timeIntervalSince1970: date.timeIntervalSince1970)
		}

		throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: String.self)
	}

	func JSONValue() throws -> AnyObject {
		return NSDate.ISO8601DateFormatter.stringFromDate(self)
	}
}
