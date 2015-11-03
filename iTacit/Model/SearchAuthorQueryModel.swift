//
//  SearchAuthorQueryModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class SearchAuthorQueryModel {

	var string = ""

	init(string: String) {
		self.string = string
	}

}

extension SearchAuthorQueryModel: SearchQuery {

	var stringQuery: String {
		return "authorNameFull:" + string
	}

}
