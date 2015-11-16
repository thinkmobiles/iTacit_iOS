//
//  UserProfileModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class UserProfileModel: BaseModel, Mappable {
    
    override var path: String {
        return "/mobile/1.0/employee/profile"
    }
    
    var id = ""
    var userId = ""
    var lastName = ""
    var firstName = ""
    var imageURL: NSURL?
    var role = ""
    var businessUnit = ""

	var fullName: String {
		return firstName + " " + lastName
	}

	var status: String {
		return role + ", " + businessUnit
	}
    
    func load(completion: CompletionHandler? = nil) {
        performRequest({ (builder) -> Void in
            builder.path = self.path
            builder.method = .POST
			builder.body = .JSON(JSON: ["id":  self.id])
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
            case "userId": userId <<- value
            case "lastName": lastName <<- value
            case "firstName": firstName <<- value
            case "imageURL": imageURL <<- value
            case "role": role <<- value
            case "businessUnit": businessUnit <<- value
            default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "id"),
                PropertyDescriptor(propertyName: "userId"),
			PropertyDescriptor(propertyName: "lastName", JSONKey: "nameLast"),
            PropertyDescriptor(propertyName: "firstName", JSONKey: "nameFirst"),
            PropertyDescriptor(propertyName: "imageURL", JSONKey: "imageUrl"),
            PropertyDescriptor(propertyName: "role", JSONKey: "roleName"),
			PropertyDescriptor(propertyName: "businessUnit", JSONKey:"businessUnitName")]
    }
}