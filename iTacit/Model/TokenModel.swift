//
//  TokenModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/1/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class TokenModel: BaseModel, Mappable {
    
    private struct Constants {
        static let accessTokenKey = "accessToken"
        static let refreshTokenKey = "refreshToken"
    }

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
		signInWithUsername("testios", password: "test")
	}

	override func defaultSuccessHandler(data: NSData?, request: NSURLRequest, response: NSHTTPURLResponse?, completion: CompletionHandler?) -> Void {
		super.defaultSuccessHandler(data, request: request, response: response, completion: completion)
		storeToKeyChain()
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
    
    // MARK: KeyChain
    
    func storeToKeyChain() {
        KeychainWrapper.setString(accessToken, forKey: Constants.accessTokenKey)
        KeychainWrapper.setString(refreshToken, forKey: Constants.refreshTokenKey)
    }
    
    class func loadFromKeyChain() -> TokenModel? {
        if let accesstoken = KeychainWrapper.stringForKey(Constants.accessTokenKey), refreshToken = KeychainWrapper.stringForKey(Constants.refreshTokenKey) {
            let tokenModel = TokenModel()
            tokenModel.accessToken = accesstoken
            tokenModel.refreshToken = refreshToken
            return tokenModel
        } else {
            return nil
        }
    }
}
