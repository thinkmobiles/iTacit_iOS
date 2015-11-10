//
//  PageListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/10/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class PageListModel<Element: BaseModel where Element: Mappable>: ListModel<Element> {

	class var requestRowCount: Int {
		return 10
	}

	required init() {
		super.init()
	}

	var loadedAll = false
	var isLoading = false

	override func load(completion: CompletionHandler? = nil) {
		objects = []
		loadedAll = false
		loadWithStartIndex(1, completion: completion)
	}

	func loadMore(completion: CompletionHandler? = nil) {
		loadWithStartIndex(objects.count, completion: completion)
	}

	private func loadWithStartIndex(startIndex: Int, completion: CompletionHandler?) {
		isLoading = true
		performRequest({ [unowned self] (builder) -> Void in
			var JSON: [String: AnyObject] = ["startIndex": startIndex, "rowCount": PageListModel.requestRowCount]
			if let searchQueryString = self.searchQuery?.stringQuery {
				JSON["query"] = searchQueryString
			}
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: JSON)
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			self?.isLoading = false
			if let data = data {
				do {
					let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
					if let JSONarray = JSON["responseRows"] as? [[String: AnyObject]] {
						let newObjects: [Element] = try JSONMapper.map(JSONarray)
						self?.objects += newObjects
						self?.loadedAll = newObjects.count < PageListModel.requestRowCount
						completion?(success: true)
					} else {
						completion?(success: true)
					}
				} catch {
					completion?(success: false)
				}
			} else {
				completion?(success: false)
			}
		}) { [weak self] (error, request, response) -> Void in
			self?.isLoading = false
			completion?(success: false)
		}
	}
}
