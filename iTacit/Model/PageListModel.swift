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
		return 50
	}

	required init() {
		super.init()
	}

	private(set) var isLoading = false
	private(set) var loadedAll = false

	override func load(completion: CompletionHandler? = nil) {
		loadedAll = false
		loadWithStartIndex(0, completion: completion)
	}

	func loadMore(completion: CompletionHandler? = nil) {
		guard !loadedAll else {
			completion?(success: false)
			return
		}
		let startIndex = objects.count == 1 ? 2: objects.count
		loadWithStartIndex(startIndex, completion: completion)
	}

	private func loadWithStartIndex(startIndex: Int, completion: CompletionHandler?) {
		isLoading = true
		performRequest({ [unowned self] (builder) -> Void in
			var JSON: [String: AnyObject] = ["startIndex": startIndex, "rowCount": PageListModel.requestRowCount]
			if let searchQueryString = self.searchQuery?.stringQuery {
				JSON["query"] = searchQueryString
			}
			if let JSONObject = self.JSONObject {
				JSON = JSON + JSONObject
			}
			builder.path = self.path
			builder.method = .POST
			builder.body = .JSON(JSON: JSON)
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			if let data = data where data.length > 0 {
				do {
					let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
					if let JSONarray = JSON["responseRows"] as? [[String: AnyObject]] {
						let newObjects: [Element] = try JSONMapper.map(JSONarray)
						self?.loadedAll = newObjects.count < PageListModel.requestRowCount
						if startIndex == 0 {
							self?.objects = newObjects
						} else {
							self?.objects += newObjects
						}
						completion?(success: true)
					} else {
						completion?(success: true)
					}
				} catch {
					completion?(success: false)
				}
			} else {
				if startIndex == 0 {
					self?.clear()
				}
				completion?(success: false)
			}
			self?.isLoading = false
		}) { [weak self] (error, request, response) -> Void in
			completion?(success: false)
			self?.isLoading = false
		}
	}
	
}
