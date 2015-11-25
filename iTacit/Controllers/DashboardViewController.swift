//
//  DashboardViewController.swift
//  iTacit
//
//  Created by Sauron Black on 10/15/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		loadOwnUserProfile()
	}

	func loadOwnUserProfile() {
		let profilesList = UserProfileListModel()
		profilesList.searchQuery = OwnUserProfileQueryModel()
		profilesList.loadOwnUserProfile { (success, user) -> Void in
			SharedStorage.sharedInstance.userProfile = user
			print("Did Load User: \(user?.id)")
		}
	}

	func updateGreeting() {
	}

}
