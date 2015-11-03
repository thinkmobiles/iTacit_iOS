//
//  ServerErrorModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

struct ServerErrorModel: ErrorType {

	enum Error: String {
		case Unknown
		case InvalidGrant = "invalid_grant"
		case InvalidToken = "invalid_token"
	}

	var error = Error.Unknown
	var errorDescription = ""

	init() {}

}

extension ServerErrorModel: KeyValueCodable {

	mutating func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "error": error <<- value
			case "errorDescription": errorDescription <<- value
			default: break
		}
	}

}

extension ServerErrorModel: Mappable {

	static var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "error"),
				PropertyDescriptor(propertyName: "errorDescription", JSONKey: "error_description")]
	}

}

extension ServerErrorModel.Error: JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> ServerErrorModel.Error {
		if let string = value as? String {
			return ServerErrorModel.Error(rawValue: string) ?? .Unknown
		}
		return ServerErrorModel.Error.Unknown
	}

	func JSONValue() throws -> AnyObject {
		return self.rawValue
	}
}

extension ServerErrorModel: CustomStringConvertible {

	var description: String {
		return "Server error: {\n\t\(error)\n\t\(errorDescription)\n}"
	}
}
