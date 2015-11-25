//
//  UserProfileListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/9/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class UserProfileListModel<T: UserProfileModel>: PageListModel<T> {
    
    typealias CompletionUserHandler = (success: Bool, user: UserProfileModel?) -> Void

	override var path: String {
		return "/mobile/1.0/employee/profile"
	}

	required init() {
		super.init()
	}
    
    func loadOwnUserProfile(completion: CompletionUserHandler? = nil) {
        load { (success) -> Void in
            completion?(success: success, user: self.objects.first)
        }
    }

}
