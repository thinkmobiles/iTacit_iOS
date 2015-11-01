//
//  RequestBuilder.swift
//  MVCNTest
//
//  Created by Sauron Black on 10/30/15.
//  Copyright © 2015 Mordor. All rights reserved.
//

import Foundation

class URLRequestBuilder {

	static var defaultHeaderFields = [String: String]()

	var baseURL: NSURL
	var path: String
	var method: URLRequestMethod
	var contentType: URLRequestContentType?
	var queryParams = [String: String]()
	var headerFields = [String: String]()
	var body: URLRequestBody?

	init(baseURL: NSURL, path: String, method: URLRequestMethod) {
		self.baseURL = baseURL
		self.path = path
		self.method = method
	}

	var URLRequest: NSURLRequest? {
		guard let URL = URL else {
			return nil
		}

		let request = NSMutableURLRequest(URL: URL)
		request.HTTPMethod = method.rawValue

		let allHeaderFields = URLRequestBuilder.defaultHeaderFields + headerFields
		if !allHeaderFields.isEmpty {
			request.allHTTPHeaderFields = allHeaderFields
		}

		if let contentType = contentType {
			request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
		}

		if let data = body?.dataForContentType(contentType ?? .ApplicationJSON) {
			request.setValue("\(data.length)", forHTTPHeaderField: "Content-Length")
			request.HTTPBody = data
		}
		
		return request
	}

	private var URL: NSURL? {
		guard let URLComponents = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: false) else {
			return nil
		}

		URLComponents.path = path

		if !queryParams.isEmpty {
			let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + URLParametersSerializer.query(queryParams)
			URLComponents.percentEncodedQuery = percentEncodedQuery
		}
		return URLComponents.URL
	}

}

enum URLRequestMethod: String {

	case GET
	case POST
	case PUT
	case DELETE
	case HEAD
	case PATCH
	case OPTIONS

}

enum URLRequestContentType: String {

	case ApplicationJSON = "application/json"
	case FormURLEncoded = "application/x-www-form-urlencoded"
}

enum URLRequestBody {

	case RawData(data: NSData)
	case JSON(JSON: AnyObject)
	case MappableObject(object: Mappable)
	case MappableObjects(objects: [Mappable])

	func dataForContentType(contentType: URLRequestContentType) -> NSData? {
		if case .RawData(let data) = self {
			return data
		} else if let JSON = JSONObject {
			switch contentType {
				case .ApplicationJSON:
					return try? NSJSONSerialization.dataWithJSONObject(JSON, options: .PrettyPrinted)
				case .FormURLEncoded:
					if let JSON = JSON as? [String: AnyObject] {
						return URLParametersSerializer.query(JSON).dataUsingEncoding(NSUTF8StringEncoding)
					}

			}
		}
		return nil
	}

	private var JSONObject: AnyObject? {
		switch self {
			case .JSON(let JSON): return JSON
			case .MappableObject(let object): return try? JSONMapper.mapToJSON(object)
			case .MappableObjects(let objects): return try? JSONMapper.mapToJSON(objects)
			default: return nil
		}
	}
}
