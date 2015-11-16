//
// Created by Sauron Black on 11/12/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import Foundation

class MessageListModel<T: MessageModel>: ListModel<T> {

	override var path: String {
		return "/mobile/1.0/messaging/message"
	}

	required init() {
		super.init()
		JSONObject = ["fields": "DEFAULT|sender", "sort": "sendDateTime:D"]
	}

}
