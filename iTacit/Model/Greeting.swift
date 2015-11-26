//
//  Greeting.swift
//  iTacit
//
//  Created by Sauron Black on 11/23/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

enum Greeting: String {

	struct Constants {
		static let morningStart = 4
		static let afternoonStart = 12
		static let eveningStart = 18
	}

	case Morning = "Good Morning"
	case Afternoon = "Good Afternoon"
	case Evening = "Good Evening"

	var localizedString: String {
		return LocalizedString(rawValue)
	}

	static func greetengForHour(hour: Int) -> Greeting {
		switch hour {
			case Constants.morningStart..<Constants.afternoonStart: return .Morning
			case Constants.afternoonStart..<Constants.eveningStart: return .Afternoon
			default: return .Evening
		}
	}

	static func remainingHours(hour: Int) -> Int {
		switch hour {
			case Constants.morningStart..<Constants.afternoonStart: return Constants.afternoonStart - hour
			case Constants.afternoonStart..<Constants.eveningStart: return Constants.eveningStart - hour
			case Constants.eveningStart..<24: return 24 - hour + Constants.morningStart
			default: return Constants.morningStart - hour
		}
	}

}