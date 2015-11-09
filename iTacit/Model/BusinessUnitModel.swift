//
//  BusinessUnitModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/6/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class BusinessUnitModel: BaseModel, Mappable {
    
    var id = ""
    var name = ""
    var parentId = ""
    var parentName = ""
    var fullName = ""
    var typeName = ""
    
    // MARK: - Mapping
    
    func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "id": id <<- value
        case "name": name <<- value
        case "parentId": parentId <<- value
        case "parentName": parentName <<- value
        case "fullName": fullName <<- value
        case "typeName": typeName <<- value
            
        default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "id"),
            PropertyDescriptor(propertyName: "name"),
            PropertyDescriptor(propertyName: "parentId"),
            PropertyDescriptor(propertyName: "parentName"),
            PropertyDescriptor(propertyName: "fullName", JSONKey: "nameFull"),
            PropertyDescriptor(propertyName: "typeName")]
    }
}