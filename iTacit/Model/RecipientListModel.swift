//
//  RecipientListModel.swift
//  iTacit
//
//  Created by Sauron Black on 11/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

enum RecipientListPath: String {

	case MessageRecipients = "/mobile/1.0/messaging/recipient"
	case AdvancedLookUpFullList = "/mobile/1.0/employee/advanced/fullList"

}

class RecipientListModel<T: RecipientModel>: ListModel<T> {

	override var path: String {
		return recipientListPath.rawValue
	}

	var recipientListPath = RecipientListPath.MessageRecipients

	required init() {
		super.init()
	}

	init(path: RecipientListPath) {
		super.init()
		recipientListPath = path
	}

	func setRecipients(recipients: [NewMessageModel.Recipient]) {
		let params = recipients.map { try! $0.JSONValue()}
		JSONObject = ["mixedList": params]
	}
}