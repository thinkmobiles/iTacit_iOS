//
//  NewsCategoryModel.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation
import UIKit

class NewsCategoryModel: BaseModel, Mappable {
    
    override var path: String {
        return "/mobile/1.0/news/article/category/%@"
    }
    
    var mostRecentArticlePublishedDate: NSDate?
    var categoryName = ""
    var categoryId = ""
    
    func load(completion: CompletionHandler? = nil) {
        performRequest({ (builder) -> Void in
            builder.path = String(format: self.path, arguments: [self.categoryId])
            builder.method = .GET
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
			case "mostRecentArticlePublishedDate": mostRecentArticlePublishedDate <<- value
			case "categoryName": categoryName <<- value
			case "categoryId": categoryId <<- value
			default: break
        }
    }
    
    class var mapping: [PropertyDescriptor] {
        return [TransformablePropertyDescriptor(propertyName: "mostRecentArticlePublishedDate", valueTransformer: DateValueTransformer.self),
            PropertyDescriptor(propertyName: "categoryName"),
            PropertyDescriptor(propertyName: "categoryId")]
    }
}