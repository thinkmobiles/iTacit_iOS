//
//  SearchReplyListModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class SearchReplyListModel: SearchStringModel {
    
    override var stringQuery: String {
        return "parentMessageId:" + string
    }
    
}