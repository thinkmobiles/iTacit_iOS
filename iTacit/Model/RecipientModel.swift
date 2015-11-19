//
//  RecipientModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class RecipientModel: BaseModel, Mappable {

	var id = ""
	var employeeId = ""
	var name = ""
	var nameFull = ""
	var imageURL: NSURL?
	var role = ""
	var businessUnit = ""
	var hasConfirmed = false
	var confirmationReadDate: NSDate?

	var fullName: String {
		return name.isEmpty ? nameFull : name
	}

	var status: String {
		return businessUnit.isEmpty ? role : role + ", " + businessUnit
	}

	// MARK: - Mapping

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "id": id <<- value
			case "employeeId": employeeId <<- value
			case "name": name <<- value
			case "nameFull": nameFull <<- value
			case "imageURL": imageURL <<- value
			case "role": role <<- value
			case "businessUnit": businessUnit <<- value
			case "confirmationReadDate": confirmationReadDate <<- value
			case "hasConfirmed": hasConfirmed <<- value
			default: break
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "id"),
			PropertyDescriptor(propertyName: "employeeId"),
			PropertyDescriptor(propertyName: "name"),
			PropertyDescriptor(propertyName: "nameFull"),
			PropertyDescriptor(propertyName: "imageURL", JSONKey: "imageUrl"),
			PropertyDescriptor(propertyName: "role", JSONKey: "roleName"),
			PropertyDescriptor(propertyName: "businessUnit", JSONKey:"businessUnit"),
			PropertyDescriptor(propertyName: "confirmationReadDate", JSONKey: "readConfirmedDateTime"),
			TransformablePropertyDescriptor(propertyName: "hasConfirmed", JSONKey: "readConfirmedYn", valueTransformer: YnStringToBoolTransformer.self)]
	}
}
