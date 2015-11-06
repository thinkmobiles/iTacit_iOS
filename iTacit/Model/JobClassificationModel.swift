//
//  JobClassificationModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/6/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class JobClassificationModel: BaseModel, Mappable {
    
    var jobClassificationId = ""
    var jobClassificationName = ""
    
    // MARK: - Mapping
    
    func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "jobClassificationId": jobClassificationId <<- value
        case "jobClassificationName": jobClassificationName <<- value
            
        default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "jobClassificationId"),
            PropertyDescriptor(propertyName: "jobClassificationName")]
    }
}