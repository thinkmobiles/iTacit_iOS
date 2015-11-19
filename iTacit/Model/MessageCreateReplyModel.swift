//
//  MessageCreateReplyModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/19/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import UIKit

class MessageCreateReplyModel: ReplyModel {

    var messageId = ""
    var senderID = ""
    var privateReply = false

    func sendReply(completion: CompletionHandler? = nil) {
        performRequest({ (builder) -> Void in
            builder.path = "/mobile/1.0/messaging/message/sendReply"
            builder.method = .POST
            builder.body = .MappableObject(object: self)
            builder.contentType = .ApplicationJSON
            }, successHandler: { (data, request, response) -> Void in
                completion?(success: true)
            }) { (error, request, response) -> Void in
                completion?(success: false)
        }
    }
    
    // MARK: - KeyValueCodable
    
    override func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "messageId": messageId <<- value
        case "senderID": senderID <<- value
        case "privateReply": privateReply <<- value
        default: break
        }
    }
    
    // MARK: - Mappable

    override class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "messageId"),
            PropertyDescriptor(propertyName: "senderID"),
            TransformablePropertyDescriptor(propertyName: "privateReply", JSONKey: "privateYn", valueTransformer: YnStringToBoolTransformer.self),
        TransformablePropertyDescriptor(propertyName: "body", valueTransformer: HTMLToAttributedStringTransformer.self)]
    }
}
