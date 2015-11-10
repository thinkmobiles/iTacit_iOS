//
//  NewsListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class NewsListModel<T: NewsModel>: PageListModel<T> {

	override var path: String {
		return "/mobile/1.0/news/article"
	}

	required init() {
		super.init()
	}

}