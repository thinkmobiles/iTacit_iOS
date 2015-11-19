//
//  RecipientSearchQuery.swift
//  iTacit
//
//  Created by Sauron Black on 11/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class RecipientSearchQuery: SearchQuery {

	var messageId = ""

	init(messageId: String) {
		self.messageId = messageId
	}

	var stringQuery: String {
		return "messageId:" + messageId
	}

}