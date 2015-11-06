//
//  PermissionGroupsModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/6/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class PermissionGroupsModel: BaseModel, Mappable {
    
    var permitionGroupId = ""
    var permitionGroupName = ""
    
    // MARK: - Mapping
    
    func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "permitionGroupId": permitionGroupId <<- value
        case "permitionGroupName": permitionGroupName <<- value
            
        default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "permitionGroupId"),
            PropertyDescriptor(propertyName: "permitionGroupName")]
    }
}
