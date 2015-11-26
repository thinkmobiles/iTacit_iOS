//
//  BannerModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/26/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class BannerModel: BaseModel {

	var title = ""
	var details: NSAttributedString?
	var imageURL: NSURL?
	var displayTime = 20.0

}

// MARK: - KeyValueCodable

extension BannerModel: KeyValueCodable {

	func setValue<T>(value: T, forKey key: String) throws {
		try validateKey(key, typeOfValue: T.self)
		switch key {
			case "title": title <<- value
			case "details": details <<- value
			case "imageURL": imageURL <<- value
			case "displayTime": displayTime <<- value
			default: break
		}
	}

}

// MARK: - Mappable

extension BannerModel: Mappable {

	class var mapping: [PropertyDescriptor] {
		return [PropertyDescriptor(propertyName: "title"),
				PropertyDescriptor(propertyName: "imageURL", JSONKey: "imageUrl"),
				PropertyDescriptor(propertyName: "displayTime"),
				TransformablePropertyDescriptor(propertyName: "details", valueTransformer: HTMLToAttributedStringTransformer.self)]
	}

}
