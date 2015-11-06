//
//  BusinessUnitModelList.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/6/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class BusinessUnitListModel<T: BusinessUnitModel>: ListModel<T> {
    
    override var path: String {
        return "/mobile/1.0/organization/businessUnit"
    }
    
    required init() {
        super.init()
    }
}