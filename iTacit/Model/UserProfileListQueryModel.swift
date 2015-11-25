//
//  UserProfileListQueryModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/25/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class UserProfileListQueryModel: SearchStringModel {
    
    override var stringQuery: String {
        return "self:Y"
    }
    
}