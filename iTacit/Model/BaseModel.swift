//
//  BaseModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/1/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class BaseModel: NSObject {

	struct Notifications {
		static let DidLoginNotification = "BaseModelDidLoginNotification"
	}

	typealias SuccessHandler = (data: NSData?, request: NSURLRequest, response: NSHTTPURLResponse?) -> Void
	typealias FailureHandler = (error: ErrorType?, request: NSURLRequest, response: NSHTTPURLResponse?) -> Void
	typealias CompletionHandler = (success: Bool) -> Void

	static let BaseURL = NSURL(string: "https://mobilesandbox.itacit.com")!
	static var token: TokenModel?

	var path: String {
		return ""
	}

	var pendingRequests = [NSURLRequest: (SuccessHandler?, FailureHandler?)]()

	var lastTask: NSURLSessionTask?

	required override init() {
		super.init()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didLoginNotification:"), name: Notifications.DidLoginNotification, object: nil)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: Notifications.DidLoginNotification, object: nil)
	}

	func performRequest(request: NSURLRequest, successHandler: SuccessHandler?, failureHandler: FailureHandler?) {
		lastTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { [weak self] (data, response, error) -> Void in
			dispatch_async(dispatch_get_main_queue()) { () -> Void in
				guard let HTTPResponse = response as? NSHTTPURLResponse else {
					failureHandler?(error: error, request: request, response: nil)
					return
				}
                
                if let body = request.HTTPBody {
                    print(String(data: body, encoding: NSUTF8StringEncoding))
                }

				if 0...299 ~= HTTPResponse.statusCode {
					successHandler?(data: data, request: request, response: HTTPResponse)
				} else if HTTPResponse.statusCode == 401 {
					self?.handleUnauthorizedResponseForRequest(request, successHandler: successHandler, failureHandler: failureHandler)
				} else  {
					var serverError: ServerErrorModel?
					if let data = data {
						serverError = (try? JSONMapper.map(data))?.first
						print(serverError)
					}
					failureHandler?(error: serverError, request: request, response: HTTPResponse)
				}
			}
		}
		lastTask?.resume()
	}

	func performRequest(requestBuilderClosure: (builder: URLRequestBuilder) -> Void, requiresToken: Bool = true, successHandler: SuccessHandler?, failureHandler: FailureHandler?) {
		let builder = URLRequestBuilder(baseURL: BaseModel.BaseURL)
		requestBuilderClosure(builder: builder)
		if let token = BaseModel.token where requiresToken {
			builder.headerFields["Authorization"] = "Bearer \(token.accessToken)"
		}
		if let request = builder.URLRequest {
			performRequest(request, successHandler: successHandler, failureHandler: failureHandler)
		}
	}

	func defaultSuccessHandler(data: NSData?, request: NSURLRequest, response: NSHTTPURLResponse?, completion: CompletionHandler?) -> Void {
		if let data = data, var mappableSelf = self as? Mappable {
			do {
				try JSONMapper.map(&mappableSelf, fromJSONData: data)
				completion?(success: true)
			} catch {
				completion?(success: false)
			}
		} else {
			completion?(success: true)
		}
	}

	func handleUnauthorizedResponseForRequest(request: NSURLRequest, successHandler: SuccessHandler?, failureHandler: FailureHandler?) {
		pendingRequests[request] = (successHandler, failureHandler)
		if let token = BaseModel.token where !token.loginInProgress {
			token.refresh()
		}
	}

	func didLoginNotification(notification: NSNotification) {
		if let token = BaseModel.token {
			let requests = pendingRequests
			pendingRequests = [:]
			for (request, handlers) in requests {
				resendRequest(request, accessToken: token.accessToken, successHandler: handlers.0, failureHandler: handlers.1)
			}
		}
	}

	func resendRequest(request: NSURLRequest, accessToken: String, successHandler: SuccessHandler?, failureHandler: FailureHandler?) {
		let mutableRequest = request.mutableCopy() as! NSMutableURLRequest
		mutableRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		performRequest(mutableRequest, successHandler: successHandler, failureHandler: failureHandler)
	}

}
