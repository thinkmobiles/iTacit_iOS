//
//  SearchCategoryQueryModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class SearchCategoryQueryModel: SearchStringModel {

	override var stringQuery: String {
		return "categoryName:" + string
	}

}
