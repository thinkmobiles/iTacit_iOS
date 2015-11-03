//
//  TokenModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/1/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class TokenModel: BaseModel, Mappable {

	override var path: String {
		return "/mobile/oauth/token"
	}

	var accessToken = ""
	var refreshToken = ""

	var loginInProgress = false

	func signInWithUsername(username: String, password: String, completion: CompletionHandler? = nil) {
		loginInProgress = true
		performRequest({ [unowned self] (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.queryParams = ["client_id": "MOBILESANDBOX", "username": username, "password": password, "grant_type": "password"]
		}, requiresToken: false, successHandler: { [weak self] (data, request, response) -> Void in
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
			self?.loginInProgress = false
			print(self)
		}) { [weak self] (error, request, response) -> Void in
			completion?(success: false)
			self?.loginInProgress = false
		}
	}

	func refresh(completion: CompletionHandler? = nil) {
		loginInProgress = true
		performRequest({ [unowned self] (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.queryParams = ["client_id": "MOBILESANDBOX", "grant_type": "refresh_token", "refresh_token": self.refreshToken]
		}, requiresToken: false, successHandler: { [weak self] (data, request, response) -> Void in
			self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
			self?.loginInProgress = false
		}) { [weak self] (error, request, response) -> Void in
			completion?(success: false)
			self?.loginInProgress = false
		}
	}

	private func relogin() {
		signInWithUsername("ph", password: "ph")
	}

	override func defaultSuccessHandler(data: NSData?, request: NSURLRequest, response: NSHTTPURLResponse?, completion: CompletionHandler?) -> Void {
		super.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DidLoginNotification, object: nil)
	}

	override func handleUnauthorizedResponseForRequest(request: NSURLRequest, successHandler: SuccessHandler?, failureHandler: FailureHandler?) {
		self.relogin()
	}

	// MARK: - Mapping

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "accessToken": accessToken <<- value
			case "refreshToken": refreshToken <<- value
			default: KeyValueCodableError.PropertyNotFound(type: self.dynamicType, key: key)
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "accessToken", JSONKey: "access_token"),
				PropertyDescriptor(propertyName: "refreshToken", JSONKey: "refresh_token")]
	}

	override var description: String {
		return "Token: {\n\taccessToken: \(accessToken)\n\trefreshToken: \(refreshToken)\n}"
	}
}

//extension TokenModel: CustomStringConvertible {
//
//	var description: String {
//		return "Token: {\n\taccessToken: \(accessToken)\n\trefreshToken: \(refreshToken)\n}"
//	}
//
//}
