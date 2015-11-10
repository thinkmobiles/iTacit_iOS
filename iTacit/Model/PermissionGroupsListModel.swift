//
//  PermissionGroupsListModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/6/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class PermissionGroupsListModel<T: PermissionGroupsModel>: ListModel<T> {
    
    override var path: String {
        return "/mobile/1.0/organization/permissionGroup"
    }
    
    required init() {
        super.init()
    }
}