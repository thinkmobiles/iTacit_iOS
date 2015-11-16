//
// Created by Sauron Black on 11/13/15.
// Copyright (c) 2015 iTacit. All rights reserved.
//

import Foundation

enum MessageCategory: String {

	case All = "ALL"
	case ActOn = "ACT ON"
	case Waiting = "WAITING"
	case ToMe = "TO ME"
	case FromMe = "FROM ME"
	case Archive = "ARCHIVE"

	var fullName: String {
		switch self {
			case .ActOn: return  "I NEED TO ACT ON"
			default: return self.rawValue
		}
	}

	var serverString: String {
		switch self {
			case .ActOn: return "ACT"
			case .ToMe: return "INBOX"
			case .FromMe: return "SENT"
			default: return self.rawValue
		}
	}

}
