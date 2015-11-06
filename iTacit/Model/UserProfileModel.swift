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
    
    var userId = ""
    var nameFull = ""
    var nameLast = ""
    var nameFirst = ""
    var imageUrl: NSURL?
    var roleName = ""
    var businessUnitName = ""
    
    func load(completion: CompletionHandler? = nil) {
        performRequest({ (builder) -> Void in
            builder.path = self.path
            builder.method = .POST
			builder.body = .JSON(JSON: ["id":  self.userId])
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
        case "userId": userId <<- value
        case "nameFull": nameFull <<- value
        case "nameLast": nameLast <<- value
        case "nameFirst": nameFirst <<- value
        case "imageUrl": imageUrl <<- value
        case "roleName": roleName <<- value
        case "businessUnitName": businessUnitName <<- value
        default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "userId"),
            PropertyDescriptor(propertyName: "nameFull"),
            PropertyDescriptor(propertyName: "nameLast"),
            PropertyDescriptor(propertyName: "nameFirst"),
            PropertyDescriptor(propertyName: "imageUrl"),
            PropertyDescriptor(propertyName: "roleName"),
            PropertyDescriptor(propertyName: "businessUnitName")]
    }
}