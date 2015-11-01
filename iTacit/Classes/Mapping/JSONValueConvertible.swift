//
//  JSONValueConvertible.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 10/2/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

protocol JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> Self
	func JSONValue() throws -> AnyObject
}

enum JSONValueConvertibleError: ErrorType {
	case FailedToConvertValue(value: Any, type: Any.Type)
	case ArrayElementIsNotConvertible(arrayElementType: Any.Type)
}

extension JSONValueConvertibleError: CustomStringConvertible {

	var description: String {
		switch self {
			case .FailedToConvertValue(let value, let type):
				return "Failed to convert element \"\(value)\" to type \"\(type)\""
			case .ArrayElementIsNotConvertible(let arrayElementType):
				return "Array element type \"\(arrayElementType)\" does not conform to JSONElementConvertible nor Serializable protocol"
		}
	}
}

