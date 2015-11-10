//
//  PageListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/10/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class PageListModel<Element: BaseModel where Element: Mappable>: ListModel<Element> {

	private let requestRowCount = 5

	required init() {
		super.init()
	}

	override func load(completion: CompletionHandler? = nil) {
		objects = []
		loadWithStartIndex(1, completion: completion)
	}

	func loadMore(completion: CompletionHandler? = nil) {
		loadWithStartIndex(objects.count, completion: completion)
	}

	private func loadWithStartIndex(startIndex: Int, completion: CompletionHandler?) {
		performRequest({ [unowned self] (builder) -> Void in
			var JSON: [String: AnyObject] = ["startIndex": startIndex, "rowCount": self.requestRowCount]
			if let searchQueryString = self.searchQuery?.stringQuery {
				JSON["query"] = searchQueryString
			}
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: JSON)
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			if let data = data {
				do {
					let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
					if let JSONarray = JSON["responseRows"] as? [[String: AnyObject]] {
						let newObjects: [Element] = try JSONMapper.map(JSONarray)
						self?.objects += newObjects
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
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}
}
