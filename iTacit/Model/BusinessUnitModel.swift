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
    
    var unitId = ""
    var unitName = ""
    var unitParentId = ""
    var unitParentName = ""
    var unitNameFull = ""
    var unitTypeName = ""
    
    // MARK: - Mapping
    
    func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "unitId": unitId <<- value
        case "unitName": unitName <<- value
        case "unitParentId": unitParentId <<- value
        case "unitTypeName": unitParentName <<- value
        case "unitNameFull": unitNameFull <<- value
        case "unitTypeName": unitTypeName <<- value
            
        default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "unitId"),
            PropertyDescriptor(propertyName: "unitName"),
            PropertyDescriptor(propertyName: "unitParentId"),
            PropertyDescriptor(propertyName: "unitParentName"),
            PropertyDescriptor(propertyName: "unitNameFull"),
            PropertyDescriptor(propertyName: "unitTypeName")]
    }
}