//
//  URLParametersSerializer.swift
//  MVCNTest
//
//  Created by Sauron Black on 10/30/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

class URLParametersSerializer {

	class func query(parameters: [String: AnyObject]) -> String {
		var components: [(String, String)] = []

		for key in parameters.keys.sort(<) {
			let value = parameters[key]!
			components += queryComponents(key, value)
		}

		return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
	}

	private class func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
		var components: [(String, String)] = []

		if let dictionary = value as? [String: AnyObject] {
			for (nestedKey, value) in dictionary {
				components += queryComponents("\(key)[\(nestedKey)]", value)
			}
		} else if let array = value as? [AnyObject] {
			for value in array {
				components += queryComponents("\(key)[]", value)
			}
		} else {
			components.append((escape(key), escape("\(value)")))
		}

		return components
	}

	private class func escape(string: String) -> String {
		let generalDelimitersToEncode = ":#[]@"
		let subDelimitersToEncode = "!$&'()*+,;="

		let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
		allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)

		var escaped = ""

		if #available(iOS 8.3, OSX 10.10, *) {
			escaped = string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
		} else {
			let batchSize = 50
			var index = string.startIndex

			while index != string.endIndex {
				let startIndex = index
				let endIndex = index.advancedBy(batchSize, limit: string.endIndex)
				let range = Range(start: startIndex, end: endIndex)

				let substring = string.substringWithRange(range)

				escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring

				index = endIndex
			}
		}
		
		return escaped
	}

}
