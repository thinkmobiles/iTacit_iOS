//
//  OrganizationsQueryModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/9/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class OrganizationsQueryModel: SearchStringModel {

    override var stringQuery: String {
        return "search:" + string
    }
}
