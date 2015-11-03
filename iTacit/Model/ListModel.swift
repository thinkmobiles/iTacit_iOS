//
//  ListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class ListModel<Element: BaseModel where Element: Mappable>: BaseModel, Mappable {

	private let requestRowCount = 50

	private var objects = [Element]()

	required init() {
		super.init()
	}

	subscript(index: Int) -> Element {
		get {
			return objects[index]
		}
		set {
			objects[index] = newValue
		}
	}

	var count: Int {
		return objects.count
	}

	var searchQuery: SearchQuery?

	func load(completion: CompletionHandler? = nil) {
		loadWithStartIndex(0, completion: completion)
	}

	func loadMore(completion: CompletionHandler? = nil) {
		loadWithStartIndex(objects.count, completion: completion)
	}

	func clear() {
		objects = []
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
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

	// MARK: - Mapping

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "objects": objects <<- value
			default: break
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "objects", JSONKey: "responseRows")]
	}

}
