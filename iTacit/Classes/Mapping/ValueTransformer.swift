//
//  ValueTransformer.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 10/2/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

protocol JSONValueTransformer: class {

	static func transformFromJSONValue(value: AnyObject) throws -> Any
	static func transformToJSONValue(value: Any) throws -> AnyObject
}

enum ValueTransformerError: ErrorType {
	case FailedToTransformValue(value: Any)
}