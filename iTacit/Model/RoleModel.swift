//
//  RoleModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class RoleModel: BaseModel {

	var id = ""
	var name = ""

}

// MARK: - KeyValueCodable

extension RoleModel: KeyValueCodable {

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "id": id <<- value
			case "name": name <<- value
			default: break
		}
	}

}

// MARK: - Mappable

extension RoleModel: Mappable {

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "id"), PropertyDescriptor(propertyName: "name")]
	}

}
