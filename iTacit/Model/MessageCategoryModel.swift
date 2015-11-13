//
// Created by Sauron Black on 11/13/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import Foundation

class MessageCategoryModel {

	var category = MessageCategory.All
	var count = 0

	init(category: MessageCategory) {
		self.category = category
	}

}
