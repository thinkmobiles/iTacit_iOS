//
//  SharedStorage.swift
//  iTacit
//
//  Created by Sauron Black on 11/25/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class SharedStorage {

	static let sharedInstance = SharedStorage()

	private init() {}

	var userProfile: UserProfileModel?
	
}
