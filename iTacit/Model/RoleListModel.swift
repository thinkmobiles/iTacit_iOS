//
//  RoleListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class RoleListModel<T: RoleModel>: ListModel<T> {

	override var path: String {
		return "/mobile/1.0/organization/role"
	}

	required init() {
		super.init()
	}

}
