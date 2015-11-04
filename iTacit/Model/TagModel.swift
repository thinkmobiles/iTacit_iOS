//
//  TagModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

struct TagModel {
	var string: String
	var attributes: [String: String]?
}

extension TagModel: Equatable {
}

func ==(lhs: TagModel, rhs: TagModel) -> Bool {
	var attibutesEqual: Bool
	if let leftAttributes = lhs.attributes, rightAttributes = rhs.attributes {
		attibutesEqual = leftAttributes == rightAttributes
	} else {
		attibutesEqual = (lhs.attributes == nil) && (rhs.attributes == nil)
	}
	return lhs.string == rhs.string && attibutesEqual
}

