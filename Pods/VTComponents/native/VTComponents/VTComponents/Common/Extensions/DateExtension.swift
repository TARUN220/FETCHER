//
//  DateExtension.swift
//  VTComponents-iOS
//
//  Created by Robin Rajasekaran on 30/01/20.
//

import Foundation


extension Date {
    
    private static let allFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year, .weekday, .weekOfYear, .weekdayOrdinal]
    private static let positiveSevenDayComponents: DateComponents = {
        var comps = DateComponents()
        comps.day = 7
        return comps
    }()
    
    private static let negativeSevenDayComponents: DateComponents = {
        var comps = DateComponents()
        comps.day = -7
        return comps
    }()
    
    public static let oneHourTimeInterval: TimeInterval = 60 * 60
    public static let oneDayTimeInterval: TimeInterval = oneHourTimeInterval * 24
    
    //MARK: - DAY
    
    public var prevDay: Date {
        return prevDay(using: calendar)
    }
    
    public var nextDay: Date {
        return nextDay(using: calendar)
    }
    
    public func startOfDay(using calendar: Calendar) -> Date {
        return calendar.startOfDay(for: self)
    }
    
    public func endOfDay(using calendar: Calendar) -> Date {
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        return calendar.date(from: comps)!
    }
    
    public func prevDay(using calendar: Calendar) -> Date {
        return adding(days: -1, using: calendar)
    }
    
    public func nextDay(using calendar: Calendar) -> Date {
        return adding(days: 1, using: calendar)
    }
    
    // MARK:- WEEK
    
    public var startOfWeek: Date {
        return startOfWeek(using: calendar)
    }
    
    public var endOfWeek: Date {
        return endOfWeek(using: calendar)
    }
    
    public func startOfWeek(using calendar: Calendar) -> Date {
        if let date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) {
            return date
        }
        
        print("VTComponents.Date.startOfWeek(using:) - this should not occur")
        return self
    }
    
    public func endOfWeek(using calendar: Calendar) -> Date {
        return nextWeek(using: calendar).addingTimeInterval(-1)
    }
    
    public func prevWeek(using calendar: Calendar) -> Date {
        return calendar.date(byAdding: Date.negativeSevenDayComponents, to: self)!
    }
    
    public func nextWeek(using calendar: Calendar) -> Date {
        return calendar.date(byAdding: Date.positiveSevenDayComponents, to: self)!
    }
    
    //MARK: - MONTH
    
    public var startOfMonth: Date {
        return startOfMonth(using: calendar)
    }
    
    public var endOfMonth: Date {
        return self.nextMonth.prevDay
    }
    
    public var nextMonth: Date {
        return nextMonth(using: calendar)
    }
    
    public var sameDayInNextMonth: Date {
        return sameDayInNextMonth(using: calendar)
    }
    
    public func startOfMonth(using calendar: Calendar) -> Date {
        var comps = calendar.dateComponents([.day, .month, .year], from: self) //Date.allFlags
        comps.day = 1
        return calendar.date(from: comps)!
    }
    
    public func nextMonth(using calendar: Calendar) -> Date {
        var comps = calendar.dateComponents([.day, .month, .year], from: self)
        let month = comps.month! + 1
        comps.day = 1
        comps.month = month
        return calendar.date(from: comps)!
    }
    
    public func sameDayInNextMonth(using calendar: Calendar) -> Date {
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        let day = comps.day!
        let month = comps.month! + 1
        comps.day = 1
        comps.month = month
        let workingDate = calendar.date(from: comps)!
        let dayRange = calendar.range(of: .day, in: .month, for: workingDate)!
        comps.day = min(day, dayRange.upperBound - dayRange.lowerBound)
        return calendar.date(from: comps)!
    }
    
    //MARK: - YEAR
    
    public var startOfYear: Date {
        return startOfYear(using: calendar)
    }
    
    public var endOfYear: Date {
        return endOfYear(using: calendar)
    }
    
    public func startOfYear(using calendar: Calendar) -> Date {
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        comps.second = 0
        comps.minute = 0
        comps.hour = 0
        comps.day = 1
        comps.month = 1
        return calendar.date(from: comps)!
    }
    
    public func endOfYear(using calendar: Calendar) -> Date {
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        comps.second = 59
        comps.minute = 59
        comps.hour = 23
        comps.day = 31
        comps.month = 12
        return calendar.date(from: comps)!
    }
    
    public func nextYear(using calendar: Calendar) -> Date {
        var comps = DateComponents()
        comps.year = 1
        return calendar.date(byAdding: comps, to: self)!
    }
    
    public func prevYear(using calendar: Calendar) -> Date {
        var comps = DateComponents()
        comps.year = -1
        return calendar.date(byAdding: comps, to: self)!
    }
    
    //MARK: - Utilities
    
    public var timeIntervalInMilliSec: TimeInterval {
        return (self.timeIntervalSince1970 * 1000)
    }
    
    // 1 = Sunday, 2 = Monday, etc.
    public func weekDay(using calendar: Calendar) -> Int {
        return calendar.component(.weekday, from: self)
    }
    
    public func monthDay(using calendar: Calendar) -> Int {
        return calendar.component(.day, from: self)
    }
    
    public func weekdayOrdinal(using calendar: Calendar) -> Int {
        return calendar.component(.weekdayOrdinal, from: self)
    }
    
    public func isWeekend(using calendar: Calendar) -> Bool {
        return calendar.isDateInWeekend(self)
    }
    
    public func isYesterday() -> Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    public func toNextNearest15Minutes(using calendar: Calendar) -> Date {
        let cal = calendar
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        comps.minute = comps.minute! + (15 - (comps.minute! % 15))
        comps.second = 0
        return cal.date(from: comps)!
    }
    
    //MARK: - Static methods
    
    public static func dateFromMilliseconds(value: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: value / 1000)
    }
    
    public static func dateFromMilliseconds(value: String) -> Date {
        return dateFromMilliseconds(value: (value as NSString).doubleValue)
    }
    
    public static func currentTimeInMilliseconds() -> UInt {
        return UInt(floor(Date().timeIntervalSince1970 * 1000))
    }
    
    //MARK: - Compare methods
    
    public func isSameMinuteAs(_ date: Date) -> Bool {
        if isSameHourAs(date) {
            let calendar = Calendar.current
            let thisComps = calendar.dateComponents([.minute], from: self)
            let otherComps = calendar.dateComponents([.minute], from: date)
            return thisComps.minute! == otherComps.minute!
        }
        return false
    }
    
    public func isSameHourAs(_ date: Date) -> Bool {
        if isSameDay(date) {
            let calendar = Calendar.current
            let thisComps = calendar.dateComponents([.hour], from: self)
            let otherComps = calendar.dateComponents([.hour], from: date)
            return thisComps.hour! == otherComps.hour!
        }
        return false
    }
    
    public func isSameDay(_ date: Date) -> Bool {
        if isSameMonthAs(date) {
            let calendar = Calendar.current
            var compSet: Set<Calendar.Component> = Set<Calendar.Component>()
            compSet.insert(Calendar.Component.day)
            let currentComps: DateComponents =  calendar.dateComponents(compSet, from: self)
            let dateComps: DateComponents = calendar.dateComponents(compSet, from: date)
            return dateComps.day! == currentComps.day!
        }
        return false
    }
    
    /// This method only validates the same month date
    public func isPreviousDayOf(_ date: Date) -> Bool {
        guard self.isSameMonthAs(date) else { return false }
        let calendar = Calendar.current
        var compSet: Set<Calendar.Component> = Set<Calendar.Component>()
        compSet.insert(Calendar.Component.day)
        let currentComps: DateComponents =  calendar.dateComponents(compSet, from: self)
        let dateComps: DateComponents = calendar.dateComponents(compSet, from: date)
        return (dateComps.day! - 1) == currentComps.day!
    }
    
    /// This method only validates the same month date
    public func isSameWeekAs(_ other: Date) -> Bool {
        if self.isSameMonthAs(other) {
            return isSameWeek(as: other)
        }
        return false
    }
    
    public func isSameWeek(as date: Date, isSameMonth: Bool) -> Bool {
        if isSameMonth {
            return isSameWeekAs(date)
        }
        return isSameWeek(as: date)
    }
    
    private func isSameWeek(as date: Date) -> Bool {
        if let selfWeek = Calendar.current.dateComponents([.weekOfYear], from: self).weekOfYear,
            let otherWeek = Calendar.current.dateComponents([.weekOfYear], from: date).weekOfYear {
            return selfWeek == otherWeek
        }
        return false
    }
    
    /// This method only validates the same year date
    public func isSameMonthAs(_ date: Date) -> Bool {
        if self.isSameYearAs(date) {
            return isSameMonth(as: date)
        }
        return false
    }
    
    public func isSameMonth(as date: Date, isSameYear: Bool) -> Bool {
        if isSameYear {
            return isSameMonthAs(date)
        }
        return isSameMonth(as: date)
    }
    
    private func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        var compSet: Set<Calendar.Component> = Set<Calendar.Component>()
        compSet.insert(Calendar.Component.month)
        let currentComps: DateComponents =  calendar.dateComponents(compSet, from: self)
        let dateComps: DateComponents = calendar.dateComponents(compSet, from: date)
        return dateComps.month! == currentComps.month!
    }
    
    public func isSameYearAs(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentComps: DateComponents =  calendar.dateComponents([.year], from: self)
        let dateComps: DateComponents = calendar.dateComponents([.year], from: date)
        return dateComps.year! == currentComps.year!
    }
    
    //MARK:-  Helper methods
    
    func adding(days: Int, using calendar: Calendar) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}


let calendar = Calendar.autoupdatingCurrent
