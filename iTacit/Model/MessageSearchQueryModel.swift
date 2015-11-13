//
// Created by Sauron Black on 11/13/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import Foundation

class MessageSearchQueryModel: SearchStringModel {

	var category = MessageCategory.All

	override var stringQuery: String {
		var query = string.isEmpty ? "" : "\(super.stringQuery)|"
		query += "filterGroup:\(category.serverString)"
		return query
	}

}
