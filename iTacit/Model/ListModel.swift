//
//  ListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/2/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class ListModel<Element: BaseModel where Element: Mappable>: BaseModel, Mappable {

	var objects = [Element]()

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
		performRequest({ [unowned self] (builder) -> Void in
			if let searchQueryString = self.searchQuery?.stringQuery {
				builder.body = .JSON(JSON: ["query": searchQueryString])
			}
			builder.path = self.path
			builder.method = .POST
			builder.contentType = .ApplicationJSON
		}, successHandler: { [weak self] (data, request, response) -> Void in
			guard let data = data where data.length > 0 else {
				self?.clear()
				completion?(success: false)
				return
			}
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

	func clear() {
		objects = []
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
