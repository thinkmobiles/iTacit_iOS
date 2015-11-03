//
//  SearchNewsQueryModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/27/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

protocol SearchQuery {

	var stringQuery: String { get }

}

class SearchNewsQueryModel {

	var string = ""
	var authorIDs = [String]()
	var categoryIDs = [String]()
    var endDate: NSDate?
    var startDate: NSDate?

	init(string: String) {
		self.string = string
	}

}

extension SearchNewsQueryModel: SearchQuery {

	var stringQuery: String {
		var  query = "search:" + string
		if !authorIDs.isEmpty {
			query += authorIDs.reduce("|authorId:") { $0 + "\($1)," }
			query.removeAtIndex(query.endIndex)
		}
		return query
	}
	
}