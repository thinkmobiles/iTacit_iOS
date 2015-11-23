//
//  SearchNewsQueryModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/27/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class SearchNewsQueryModel: SearchStringModel {

	var authorIDs = [String]()
	var categoryIDs = [String]()
    var endDate: NSDate?
    var startDate: NSDate?

	override var stringQuery: String {
		var query = "search:" + string
		if !authorIDs.isEmpty {
			query += "|authorId:" + authorIDs.joinWithSeparator(",")
		}
		if !categoryIDs.isEmpty {
			query += "|categoryId:" + categoryIDs.joinWithSeparator(",")
		}
		if let startDate = startDate {
			query += "|startDate:\(DateValueTransformer.dateFormatter.stringFromDate(startDate))"
			if let endDate = endDate {
				query += ",\(DateValueTransformer.dateFormatter.stringFromDate(endDate))"
			}
		}
		return query
	}

	func copy() -> SearchNewsQueryModel {
		let copyModel = SearchNewsQueryModel(string: string)
		copyModel.authorIDs = authorIDs
		copyModel.categoryIDs = categoryIDs
		copyModel.endDate = endDate?.copy() as? NSDate
		copyModel.startDate = startDate?.copy() as? NSDate
		return copyModel
	}
	
}
