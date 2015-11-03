//
//  SearchAuthorQueryModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class SearchAuthorQueryModel: SearchStringModel {

	override var stringQuery: String {
		return "authorNameFull:" + string
	}

}
