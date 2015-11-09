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
    
    var businessUnitId = ""
    var businessUnitName = ""
    var businessUnitParentId = ""
    var businessUnitParentName = ""
    var businessUnitNameFull = ""
    var businessUnitTypeName = ""
    
    // MARK: - Mapping
    
    func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "businessUnitId": businessUnitId <<- value
        case "businessUnitName": businessUnitName <<- value
        case "businessUnitParentId": businessUnitParentId <<- value
        case "businessUnitParentName": businessUnitParentName <<- value
        case "businessUnitNameFull": businessUnitNameFull <<- value
        case "businessUnitTypeName": businessUnitTypeName <<- value
            
        default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "businessUnitId", JSONKey: "id"),
            PropertyDescriptor(propertyName: "businessUnitName", JSONKey: "name"),
            PropertyDescriptor(propertyName: "businessUnitParentId", JSONKey: "parentId"),
            PropertyDescriptor(propertyName: "businessUnitParentName", JSONKey: "parentName"),
            PropertyDescriptor(propertyName: "businessUnitNameFull", JSONKey: "nameFull"),
            PropertyDescriptor(propertyName: "businessUnitTypeName", JSONKey: "typeName")]
    }
}