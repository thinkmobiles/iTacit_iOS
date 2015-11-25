//
//  GreetingManager.swift
//  iTacit
//
//  Created by Sauron Black on 11/23/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

class GreetingManager: NSObject {

	struct Notifications {
		static let didChangeGreeting = "GreetingManagerDidChangeGreeting"
	}

	static let sharedInstance = GreetingManager()

	private var timer: NSTimer?
	private(set) var greeting = Greeting.Morning {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(Notifications.didChangeGreeting, object: nil)
		}
	}

	private var currentTime: (hour: Int, minute: Int, second: Int) {
		let components = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: NSDate())
		return (hour: components.hour, minute: components.minute, second: components.second)
	}

	private override init() {
		super.init()
		updateGreeting()
	}

	func remainingTimeIntervalForTime(time: (hour: Int, minute: Int, second: Int)) -> NSTimeInterval {
		return Double((Greeting.remainingHours(time.hour) * 60 - time.minute) * 60 - time.second)
	}

	private func updateGreeting() {
		let time = currentTime
		greeting = Greeting.greetengForHour(time.hour)
		timer?.invalidate()
		let remainingTimeInterval = remainingTimeIntervalForTime(time)
		timer = NSTimer.scheduledTimerWithTimeInterval(remainingTimeInterval, target: self, selector: Selector("updateGreeting"), userInfo: nil, repeats: false)
	}

}