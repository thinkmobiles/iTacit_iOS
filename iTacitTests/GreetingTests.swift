//
//  GreetingTests.swift
//  iTacit
//
//  Created by Sauron Black on 11/24/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import XCTest
@testable import iTacit

class GreetingTests: XCTestCase {
    

	func testGreetingForHour() {
		XCTAssertEqual(Greeting.greetengForHour(Greeting.Constants.morningStart), Greeting.Morning)
		XCTAssertEqual(Greeting.greetengForHour(6), Greeting.Morning)
		XCTAssertEqual(Greeting.greetengForHour(10), Greeting.Morning)
		XCTAssertEqual(Greeting.greetengForHour(11), Greeting.Morning)
		XCTAssertEqual(Greeting.greetengForHour(Greeting.Constants.afternoonStart), Greeting.Afternoon)
		XCTAssertEqual(Greeting.greetengForHour(15), Greeting.Afternoon)
		XCTAssertEqual(Greeting.greetengForHour(17), Greeting.Afternoon)
		XCTAssertEqual(Greeting.greetengForHour(Greeting.Constants.eveningStart), Greeting.Evening)
		XCTAssertEqual(Greeting.greetengForHour(20), Greeting.Evening)
		XCTAssertEqual(Greeting.greetengForHour(23), Greeting.Evening)
		XCTAssertEqual(Greeting.greetengForHour(0), Greeting.Evening)
		XCTAssertEqual(Greeting.greetengForHour(1), Greeting.Evening)
		XCTAssertEqual(Greeting.greetengForHour(3), Greeting.Evening)
		XCTAssertEqual(Greeting.greetengForHour(4), Greeting.Morning)
	}

	func testRemaningHours() {
		XCTAssertEqual(Greeting.remainingHours(6), 6)
		XCTAssertEqual(Greeting.remainingHours(11), 1)
		XCTAssertEqual(Greeting.remainingHours(12), 6)
		XCTAssertEqual(Greeting.remainingHours(18), 10)
		XCTAssertEqual(Greeting.remainingHours(23), 5)
		XCTAssertEqual(Greeting.remainingHours(0), 4)
		XCTAssertEqual(Greeting.remainingHours(3), 1)
	}

	func testRemainingTime() {
		let greetingManager = GreetingManager.sharedInstance
		XCTAssertEqual(greetingManager.remainingTimeIntervalForTime((hour: 6, minute: 0, second: 0)), 6 * 60 * 60)
		XCTAssertEqual(greetingManager.remainingTimeIntervalForTime((hour: 6, minute: 40, second: 30)), ((5 * 60) + 19) * 60 + 30)
		XCTAssertEqual(greetingManager.remainingTimeIntervalForTime((hour: 11, minute: 40, second: 30)), 19 * 60 + 30)
		XCTAssertEqual(greetingManager.remainingTimeIntervalForTime((hour: 23, minute: 29, second: 40)), (4 * 60 + 30) * 60 + 20)
		XCTAssertEqual(greetingManager.remainingTimeIntervalForTime((hour: 2, minute: 20, second: 0)), (60 + 40) * 60)
	}

}
