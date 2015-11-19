//
//  ReplyModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 11/17/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class ReplyModel: BaseModel, Mappable {
    
    var id = ""
    var parentMessageId = ""
    var sendDateTime: NSDate?
    var body: NSAttributedString?
    var sender: UserProfileModel?
    var readConfirmed = false
    var replyPrivate = false
    var replyMethodEmail = false
    var replyMethodSMS = true
    var resultSetRowId = 0
    
    func load(completion: CompletionHandler? = nil) {
        performRequest({ (builder) -> Void in
            builder.path = String(format: self.path, arguments: [self.parentMessageId])
            builder.method = .GET
            }, successHandler: { [weak self] (data, request, response) -> Void in
                self?.defaultSuccessHandler(data, request: request, response: response, completion: completion)
            }) { (error, request, response) -> Void in
                completion?(success: false)
        }
    }
    
    // MARK: - KeyValueCodable
    
    
    func setValue<T>(value: T, forKey key: String) throws {
        try validateKey(key, typeOfValue: T.self)
        switch key {
        case "id": id <<- value
        case "parentMessageId": parentMessageId <<- value
        case "sendDateTime": sendDateTime <<- value
        case "body": body <<- value
        case "sender": sender <<- value
        case "readConfirmed": readConfirmed <<- value
        case "replyMethodEmail": replyMethodEmail <<- value
        case "replyMethodSMS": replyMethodSMS <<- value
        case "resultSetRowId": resultSetRowId <<- value
        case "replyPrivate": replyPrivate <<- value
        default: break
        }
    }
    
    // MARK: - Mappable
    
    class var mapping: [PropertyDescriptor] {
        return [PropertyDescriptor(propertyName: "id"),
            PropertyDescriptor(propertyName: "parentMessageId"),
            PropertyDescriptor(propertyName: "sendDateTime"),
            TransformablePropertyDescriptor(propertyName: "readConfirmed", JSONKey: "readConfirmedYn", valueTransformer: YnStringToBoolTransformer.self),
            TransformablePropertyDescriptor(propertyName: "replyMethodEmail", JSONKey: "replyMethodEmailYn", valueTransformer: YnStringToBoolTransformer.self),
            TransformablePropertyDescriptor(propertyName: "replyMethodSMS", JSONKey: "replyMethodSMSYn", valueTransformer: YnStringToBoolTransformer.self),
            TransformablePropertyDescriptor(propertyName: "replyPrivate", JSONKey: "replyPrivateYn", valueTransformer: YnStringToBoolTransformer.self),
            PropertyDescriptor(propertyName: "resultSetRowId"),
            PropertyDescriptor(propertyName: "sender"),
            TransformablePropertyDescriptor(propertyName: "body", valueTransformer: HTMLToAttributedStringTransformer.self)]
    }
}
