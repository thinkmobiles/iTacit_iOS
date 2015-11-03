//
//  timeAgoExtension.swift
//  iTacit
//
//  Created by Sergey Sheba on 11/3/15.
//  Copyright © 2015 iTacit. All rights reserved.
//

import Foundation

let Minute = 60.0
let Hour = 60 * Minute
let Day = 24 * Hour
let Month = 30 * Day
let Year = 365 * Day

extension NSDate {
    
    func timeAgoStringRepresentation() -> String {
        let secondsLeft = abs(self.timeIntervalSinceNow)
        
        if secondsLeft < Minute {
            return "\(self.secondsString())"
        }
        
        if secondsLeft < Hour {
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
        let minutes = Int(abs(self.timeIntervalSinceNow)/Minute)
        return "\(minutes) min\(minutes > 1 ? "s" : "") ago"
    }
    
    private func daysString() -> String {
        let days = Int(abs(self.timeIntervalSinceNow)/Day)
        return "\(days) day\(days > 1 ? "s" : "") ago"
    }
    
    private func monthsString() -> String {
        let months = Int(abs(self.timeIntervalSinceNow)/Month)
        return "\(months) month\(months > 1 ? "s" : "") ago"
    }

    private func yearsString() -> String {
        let years = Int(abs(self.timeIntervalSinceNow)/Year)
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
    
    // MARK:
    private func isLastMonth() -> Bool {
        let days = Int(abs(self.timeIntervalSinceNow)/Day)
        let currentMonth = NSCalendar.currentCalendar().components([NSCalendarUnit.Month], fromDate: NSDate())
        let selfMonth = NSCalendar.currentCalendar().components([NSCalendarUnit.Month], fromDate: self)
        
        return days < 31 || currentMonth == selfMonth
    }
    
    private func isLastYear() -> Bool {
        let days = Int(abs(self.timeIntervalSinceNow)/Day)
        let currentYear = NSCalendar.currentCalendar().components([NSCalendarUnit.Year], fromDate: NSDate())
        let selfYear = NSCalendar.currentCalendar().components([NSCalendarUnit.Year], fromDate: self)

        return days < 366 || currentYear == selfYear
    }
}