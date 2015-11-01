//
//  KeyValueCodable.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 9/10/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

protocol KeyValueCodable {

	func childForKey(key: String) throws -> Mirror.Child
	mutating func setValue<T>(value: T, forKey key: String) throws
	
}

extension KeyValueCodable {

	final func typeOfValueForKey(key: String) throws -> Any.Type {
		return try childForKey(key).value.dynamicType
	}

	final func validateKey<T>(key: String, typeOfValue: T.Type) throws -> Mirror.Child {
		let child = try childForKey(key)
		if !(child.value is T) {
			throw KeyValueCodableError.TypeInconsistency(actualType: typeOfValue, expectedType: child.value.dynamicType)
		}
		return child
	}

	final func valueForKey<T>(key: String) throws -> T {
		let child = try validateKey(key, typeOfValue: T.self)
		return child.value as! T
	}

	final func anyValueForKey(key: String) throws -> Any {
		let child = try childForKey(key)
		return child.value
	}

	func childForKey(key: String) throws -> Mirror.Child {

		func findChildForKey(key: String, mirror: Mirror) -> Mirror.Child? {
			let index = mirror.children.indexOf { $0.label == key }
			if let index = index {
				return mirror.children[index]
			} else if let superClassMirror = mirror.superclassMirror() {
				return findChildForKey(key, mirror: superClassMirror)
			}
			return nil
		}

		if key.isEmpty {
			throw KeyValueCodableError.KeyIsEmpty
		}
		let mirror = Mirror(reflecting: self)
		guard let child = findChildForKey(key, mirror: mirror) else {
			throw KeyValueCodableError.PropertyNotFound(type: self.dynamicType, key: key)
		}
		return child
	}
	
}

infix operator <<- {}
func <<- <T>(inout left: T, right: Any) {
	left = right as! T
}

enum KeyValueCodableError: ErrorType, CustomStringConvertible {
	case KeyIsEmpty
	case PropertyNotFound(type: Any, key: String)
	case TypeInconsistency(actualType: Any, expectedType: Any)
	
	var description: String {
		switch self {
		case .KeyIsEmpty:
			return "Key cannot be empty."
		case .PropertyNotFound(let type, let key):
			return "\(type) doesn't have property named \"\(key)\"."
		case .TypeInconsistency(let actualType, let expectedType):
			return "The stored value type \"\(actualType)\" does not match the expected type \"\(expectedType)\"."
		}
	}
}
