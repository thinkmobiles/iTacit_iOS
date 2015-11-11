//
//  SearchStringModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

protocol SearchQuery {

	var stringQuery: String { get }

}

class SearchStringModel: SearchQuery {

	var string = ""

	init() {}

	init(string: String) {
		self.string = string
	}

	var stringQuery: String {
		return "search:" + string
	}
	
}