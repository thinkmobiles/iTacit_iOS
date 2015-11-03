//
//  SearchStringModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class SearchStringModel: SearchQuery {

	var string = ""

	init(string: String) {
		self.string = string
	}

	var stringQuery: String {
		return "authorNameFull:" + string
	}
	
}