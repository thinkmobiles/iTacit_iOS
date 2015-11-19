//
//  NewMessageModel.swift
//  iTacit
//
//  Created by MaksymRachytskyy on 10/30/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class NewMessageModel: BaseMessageModel {

	struct Notifications {
		static let DidUpdateRecipients = "NewMessageModelDidUpdateRecipients"
	}

	override var path: String {
		return "/mobile/1.0/messaging/message/new"
	}

	var recipients = [Recipient]() {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DidUpdateRecipients, object: nil)
		}
	}

	func validate() throws {
		guard !recipients.isEmpty else {
			throw Error.NoRecipients
		}
		guard let body = body where !body.string.isEmpty else {
			throw Error.NoBody
		}
		guard !subject.isEmpty else {
			throw Error.NoSubject
		}
	}

	func send(completion: CompletionHandler? = nil) throws {
		try validate()
		performRequest({ [unowned self] (builder) -> Void in
			builder.path = self.path
			builder.method = .POST
			builder.contentType = .ApplicationJSON
			builder.body = .MappableObject(object: self)
		}, successHandler: { (data, request, response) -> Void in
			completion?(success: true)
		}) { (error, request, response) -> Void in
			completion?(success: false)
		}
	}

	// MARK: - KeyValueCodable

	override func setValue<T>(value: T, forKey key: String) throws {
		try super.setValue(value, forKey: key)
		switch key {
			case "recipients": recipients <<- value
			default: break
		}
	}

	// MARK: - Mappable

	override class var mapping: [PropertyDescriptor] {
		return super.mapping + [PropertyDescriptor(propertyName: "recipients")]
	}
}

// MARK: - Recipient

extension NewMessageModel {

	enum Recipient {
		case MyDirectReports
		case MyIndirectReports
		case MyCoWorkers
		case MyJobClassification
		case MyBusinessUnits
		case Employee(userProfile: UserProfileModel)
		case JobClassification(jobClassification: JobClassificationModel)
		case BusinessUnit(businessUnit: BusinessUnitModel)
		case Role(role: RoleModel)
		case PermissionGroup(permissionGroup: PermissionGroupsModel)
	}

}

// MARK: - Recipient: Equatable

extension NewMessageModel.Recipient: Equatable {
}

func ==(lhs: NewMessageModel.Recipient, rhs: NewMessageModel.Recipient) -> Bool {
	switch (lhs, rhs) {
		case (.Employee(let lUser), .Employee(let rUser)): return lUser.id == rUser.id
		case (.JobClassification(let lJob), .JobClassification(let rJob)): return lJob.id == rJob.id
		case (.BusinessUnit(let lBusiness), .BusinessUnit(let rBusiness)): return lBusiness.id == rBusiness.id
		case (.Role(let lRole), .Role(let rRole)): return lRole.id == rRole.id
		case (.PermissionGroup(let lGroup), .PermissionGroup(let rGroup)): return lGroup.id == rGroup.id
		case (.MyDirectReports, .MyDirectReports): return true
		case (.MyIndirectReports, .MyIndirectReports): return true
		case (.MyCoWorkers, .MyCoWorkers): return true
		case (.MyJobClassification, .MyJobClassification): return true
		case (.MyBusinessUnits, .MyBusinessUnits): return true
		default: return false
	}
}

// MARK: - Recipient: JSONValueConvertible

extension NewMessageModel.Recipient: JSONValueConvertible {

	static func convertFromJSONValue(value: AnyObject) throws -> NewMessageModel.Recipient {
		throw JSONValueConvertibleError.FailedToConvertValue(value: value, type: NewMessageModel.Recipient.self)
	}

	func JSONValue() throws -> AnyObject {
		switch self {
			case .MyDirectReports: return ["myDirectReports": "Y"]
			case .MyIndirectReports: return ["myIndirectReport": "Y"]
			case .MyCoWorkers: return ["myCoworkers": "Y"]
			case .MyJobClassification: return ["myPositions": "Y"]
			case .MyBusinessUnits: return ["myBusinessUnits": "Y"]
			case .Employee(let userProfile): return ["employeeId": userProfile.id]
			case .JobClassification(let jobClassification): return ["jobClassificationId": jobClassification.id]
			case .BusinessUnit(let businessUnit): return ["businessUnitId": businessUnit.id]
			case .Role(let role): return ["roleId": role.id]
			case .PermissionGroup(let permissionGroup): return ["permissionGroupId": permissionGroup.id]
		}
	}

}

// MARK: - Recipient: CustomStringConvertible

extension NewMessageModel.Recipient: CustomStringConvertible {

	var description: String {
		switch self {
			case .MyDirectReports: return "MY DIRECT REPORTS"
			case .MyIndirectReports: return "MY INDIRECT REPORTS"
			case .MyCoWorkers: return "MY CO-WORKERS"
			case .MyJobClassification: return "MY JOB CLASSIFICATION"
			case .MyBusinessUnits: return "MY BUSINESS UNIT"
			case .Employee(let userProfile): return "EMPLOYEE: " + userProfile.id
			case .JobClassification(let jobClassification): return "JOB CLASSIFICATION: " + jobClassification.id
			case .BusinessUnit(let businessUnit): return "BUSINESS UNIT: " + businessUnit.id
			case .Role(let role): return "ROLE: " + role.id
			case .PermissionGroup(let permissionGroup): return "PERMISSION GROUP: " + permissionGroup.id
		}
	}

}

// MARK: - Error 

extension NewMessageModel {

	enum Error: ErrorType {
		case NoRecipients
		case NoBody
		case NoSubject
	}

}

// MARK: - Error: CustomStringConvertible

extension NewMessageModel.Error: CustomStringConvertible {

	var description: String {
		switch self {
			case .NoRecipients: return "No Recipients"
			case .NoBody: return "Body is empty"
			case .NoSubject: return "Subject (on UI: Topic) is empty"
		}
	}

}
