//
//  JSONMapper.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 10/2/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

final class JSONMapper {

	typealias JSONObject = [String: AnyObject]

	enum Error: ErrorType {
		case InvalidJSONObject(invalidJSON: AnyObject)
	}

}

// MARK: - Mapping into "mappable" from JSON

extension JSONMapper {

	class func map(inout object: Mappable, fromJSON JSON: JSONObject) throws {
		for propertyDescriptor in object.dynamicType.mapping {
			if let JSONValue = JSON[propertyDescriptor.JSONKey] {
				if let transformablePropertyDescriptor = propertyDescriptor as? TransformablePropertyDescriptor {
					let value = try transformablePropertyDescriptor.valueTransformer.transformFromJSONValue(JSONValue)
					try object.setValue(value, forKey: propertyDescriptor.propertyName)
				} else {
					let propertyType = try object.typeOfValueForKey(propertyDescriptor.propertyName)
					if let mappableType = propertyType as? Mappable.Type {
						if let innerJSON = JSONValue as? JSONObject {
							var innerObject = mappableType.init()
							try map(&innerObject, fromJSON: innerJSON)
							try object.setValue(innerObject, forKey: propertyDescriptor.propertyName)
						}
					} else if let valueConvertibleType = propertyType as? JSONValueConvertible.Type {
						let value = try valueConvertibleType.convertFromJSONValue(JSONValue)
						try object.setValue(value, forKey: propertyDescriptor.propertyName)
					}
				}
			}
		}
	}

	class func map<T: Mappable>(JSON: JSONObject) throws -> T {
		var object = (T.init() as Mappable)
		try map(&object, fromJSON: JSON)
		return object as! T
	}

	class func map<T: Mappable>(JSONArray: [JSONObject]) throws -> [T] {
		return try JSONArray.map { try map($0) }
	}

	class func map<T: Mappable>(JSON: AnyObject) throws -> [T] {
		if let JSON = JSON as? JSONObject {
			return [try map(JSON)]
		} else if let JSONArray = JSON as? [JSONObject] {
			return try map(JSONArray)
		} else {
			throw Error.InvalidJSONObject(invalidJSON: JSON)
		}
	}

	class func map<T: Mappable>(data: NSData) throws -> [T] {
		let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
		return try map(JSON)
	}

}

// MARK: - Mapping into JSON from "mappable"

extension JSONMapper {

	class func mapToJSON(object: Mappable) throws -> JSONObject {
		var JSON = JSONObject()
		for propertyDescriptor in object.dynamicType.mapping {
			let value = try object.anyValueForKey(propertyDescriptor.propertyName)
			if let Mappable = value as? Mappable {
				let embededJSON = try JSONMapper.mapToJSON(Mappable)
				JSON[propertyDescriptor.JSONKey] = embededJSON
			} else {
				if let transformablePropertyDescriptor = propertyDescriptor as? TransformablePropertyDescriptor {
					if let optionalJSONElementConvertible = value as? OptionalJSONElementConvertible {
						if let value = optionalJSONElementConvertible.optionalAny {
							JSON[propertyDescriptor.JSONKey] = try transformablePropertyDescriptor.valueTransformer.transformToJSONValue(value)
						}
					} else {
						JSON[propertyDescriptor.JSONKey] = try transformablePropertyDescriptor.valueTransformer.transformToJSONValue(value)
					}
				} else if let valueConvertible = value as? JSONValueConvertible {
					let value = try valueConvertible.JSONValue()
					JSON[propertyDescriptor.JSONKey] = value
				}
			}
		}
		return JSON
	}

	class func mapToJSON(objects: [Mappable]) throws -> [JSONObject] {
		return try objects.map { try mapToJSON($0) }
	}

	class func mapToJSONData(object: Mappable) throws -> NSData {
		let JSON = try mapToJSON(object)
		if NSJSONSerialization.isValidJSONObject(JSON) {
			return try NSJSONSerialization.dataWithJSONObject(JSON, options: .PrettyPrinted)
		} else {
			throw Error.InvalidJSONObject(invalidJSON: JSON)
		}
	}

	class func mapToJSONData(objects: [Mappable]) throws -> NSData {
		let JSON = try mapToJSON(objects)
		return try NSJSONSerialization.dataWithJSONObject(JSON, options: .PrettyPrinted)
	}
}

extension JSONMapper.Error: CustomStringConvertible {

	var description: String {
		switch self {
			case .InvalidJSONObject(let invalidJSON): return "Input JSON object is invalid: \(invalidJSON)"
		}
	}

}

// MARK: - Optional

private protocol OptionalJSONElementConvertible: JSONValueConvertible {

	var optionalAny: Any? { get }
}

extension Optional: OptionalJSONElementConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> Optional<Wrapped> {
		guard !(value is NSNull) else {
			return nil
		}

		if let valueConvertibleType = Wrapped.self as? JSONValueConvertible.Type {
			let value = try valueConvertibleType.convertFromJSONValue(value)
			return value as? Wrapped
		} else if let mappableType = Wrapped.self as? Mappable.Type, JSON = value as? [String: AnyObject] {
			var object = (mappableType.init() as Mappable)
			try JSONMapper.map(&object, fromJSON: JSON)
			return object as? Wrapped
		} else {
			return nil
		}
	}

	func JSONValue() throws -> AnyObject {
		switch self {
			case .Some(let value) where value is JSONValueConvertible:
				return try (value as! JSONValueConvertible).JSONValue()
			case .Some(let value) where value is Mappable:
				return try JSONMapper.mapToJSON(value as! Mappable)
			default: return NSNull()
		}
	}

	var optionalAny: Any? {
		switch self {
			case .None: return nil
			case .Some(let wrapped): return wrapped
		}
	}

}

// MARK: - Array

extension Array: JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> [Element] {
		if let elementType = Element.self as? JSONValueConvertible.Type {
			guard let JSONArray = value as? [AnyObject] else {
				throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: [Element].self)
			}
			return try JSONArray.map { try elementType.convertFromJSONValue($0) as! Element }
		} else if let mappableType = Element.self as? Mappable.Type {
			guard let JSONArray = value as? [[String: AnyObject]] else {
				throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: [Element].self)
			}
			let array = try JSONArray.map() { (JSON) -> Element in
				var object = (mappableType.init() as Mappable)
				try JSONMapper.map(&object, fromJSON: JSON)
				return object as! Element
			}
			return array
		}

		throw JSONValueConvertibleError.ArrayElementIsNotConvertible(arrayElementType: Element.self)
	}

	func JSONValue() throws -> AnyObject {
		if let _ = Element.self as? JSONValueConvertible.Type {
			return try self.map { try ($0 as! JSONValueConvertible).JSONValue() }
		} else if let _ = Element.self as? Mappable.Type {
			return try self.map { try JSONMapper.mapToJSON($0 as! Mappable) }
		}

		throw JSONValueConvertibleError.ArrayElementIsNotConvertible(arrayElementType: Element.self)
	}
	
}
