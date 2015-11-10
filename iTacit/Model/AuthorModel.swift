//
//  AuthorModel.swift
//  iTacit
//
//  Created by Sergey Sheba on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class AuthorModel: BaseModel, Mappable {

	var id = ""
    var roleName = ""
    var mostRecentArticlePublishDate: NSDate?
    var fullName = ""
    var imageURL: NSURL?

	// MARK: - Mapping

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "id": id <<- value
			case "roleName": roleName <<- value
			case "mostRecentArticlePublishDate": mostRecentArticlePublishDate <<- value
			case "fullName": fullName <<- value
			case "imageURL": imageURL <<- value
			default: break
		}
	}

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "id", JSONKey: "authorId"),
			PropertyDescriptor(propertyName: "roleName", JSONKey: "authorRoleName"),
			PropertyDescriptor(propertyName: "fullName", JSONKey: "authorNameFull"),
			PropertyDescriptor(propertyName: "imageURL", JSONKey: "authorImageUrl"),
			TransformablePropertyDescriptor(propertyName: "mostRecentArticlePublishDate", valueTransformer: DateValueTransformer.self)]
	}

}
