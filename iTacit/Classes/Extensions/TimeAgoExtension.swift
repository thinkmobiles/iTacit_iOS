//
//  timeAgoExtension.swift
//  iTacit
//
//  Created by Sergey Sheba on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

extension NSDate {

	private struct Constants {

		static let minute = 60.0
		static let hour = 60.0 * minute
		static let day = 24.0 * hour
		static let month = 30 * day
		static let year = 365 * day

	}
    
    func timeAgoStringRepresentation() -> String {
        let secondsLeft = abs(self.timeIntervalSinceNow)
        
        if secondsLeft < Constants.minute {
            return "\(self.secondsString())"
        }
        
        if secondsLeft < Constants.hour {
            return "\(self.minutesString())"
        }
        
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInToday(self) {
            return "\(self.todayString())"
        }
        
        if calendar.isDateInYesterday(self) {
            return "\(self.yesterdayString())"
        }
        
        if self.isLastMonth() {
            return "\(self.daysString())"
        }
        
        if self.isLastYear() {
            return "\(self.monthsString())"
        }
        
        return "\(self.yearsString())"
    }
    
    // MARK:
    private func secondsString() -> String {
        let seconds = Int(abs(self.timeIntervalSinceNow))
        return "\(seconds) sec\(seconds > 1 ? "s" : "") ago"
    }
    
    private func minutesString() -> String {
        let minutes = Int(abs(self.timeIntervalSinceNow) / Constants.minute)
        return "\(minutes) min\(minutes > 1 ? "s" : "") ago"
    }
    
    private func daysString() -> String {
        let days = Int(abs(self.timeIntervalSinceNow) / Constants.day)
        return "\(days) day\(days > 1 ? "s" : "") ago"
    }
    
    private func monthsString() -> String {
        let months = Int(abs(self.timeIntervalSinceNow) / Constants.month)
        return "\(months) month\(months > 1 ? "s" : "") ago"
    }

    private func yearsString() -> String {
        let years = Int(abs(self.timeIntervalSinceNow) / Constants.year)
        return "\(years) year\(years > 1 ? "s" : "") ago"
    }
    
    private func yesterdayString() -> String {
        return "Yesterday, \(self.todayString())"
    }
    
    private func todayString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter.stringFromDate(self)
    }
    
    // MARK: -

    private func isLastMonth() -> Bool {
        let days = Int(abs(self.timeIntervalSinceNow) / Constants.day)
        let currentMonth = NSCalendar.currentCalendar().components([NSCalendarUnit.Month], fromDate: NSDate())
        let selfMonth = NSCalendar.currentCalendar().components([NSCalendarUnit.Month], fromDate: self)
        
        return days < 31 || currentMonth == selfMonth
    }
    
    private func isLastYear() -> Bool {
        let days = Int(abs(self.timeIntervalSinceNow) / Constants.day)
        let currentYear = NSCalendar.currentCalendar().components([NSCalendarUnit.Year], fromDate: NSDate())
        let selfYear = NSCalendar.currentCalendar().components([NSCalendarUnit.Year], fromDate: self)

        return days < 366 || currentYear == selfYear
    }
}
