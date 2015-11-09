//
//  UserProfileListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/9/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class UserProfileListModel<T: UserProfileModel>: ListModel<T> {

	override var path: String {
		return "/mobile/1.0/employee/profile"
	}

	required init() {
		super.init()
	}
}
