//
//  ReplyListModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class ReplyListModel<T: ReplyModel>: PageListModel<T> {
    
    override var path: String {
        return "/mobile/1.0/messaging/reply"
    }
    
    required init() {
        super.init()
        JSONObject = ["fields": "DEFAULT|sender", "sort": "sendDateTime:D"]
    }
}