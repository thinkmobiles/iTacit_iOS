//
//  PropertyDescriptor.swift
//  Swift_KVC_Serialization
//
//  Created by Sauron Black on 10/2/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

class PropertyDescriptor {

	let propertyName: String
	let JSONKey: String

	init(propertyName: String, JSONKey: String) {
		self.propertyName = propertyName
		self.JSONKey = JSONKey
	}

	convenience init(propertyName: String) {
		self.init(propertyName: propertyName, JSONKey: propertyName)
	}

}

class TransformablePropertyDescriptor: PropertyDescriptor {

	let valueTransformer: JSONValueTransformer.Type

	init(propertyName: String, JSONKey: String, valueTransformer: JSONValueTransformer.Type) {
		self.valueTransformer = valueTransformer
		super.init(propertyName: propertyName, JSONKey: JSONKey)
	}

	convenience init(propertyName: String, valueTransformer: JSONValueTransformer.Type) {
		self.init(propertyName: propertyName, JSONKey: propertyName, valueTransformer: valueTransformer)
	}
	
}
