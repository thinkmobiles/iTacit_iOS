//
//  AuthorListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class AuthorListModel<T: AuthorModel>: ListModel<T> {

	override var path: String {
		return "/mobile/1.0/news/article/author "
	}

	required init() {
		super.init()
	}
	
}