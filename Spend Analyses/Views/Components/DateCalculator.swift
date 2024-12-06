//
//  DateCalculator.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 04/12/24.
//

import SwiftUI

struct DateCalculator {
    static func getStartAndEndOfDay(for date: Date = Date()) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfDay = calendar.startOfDay(for: date) as Date? else { return nil }
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        return (start: startOfDay, end: endOfDay ?? startOfDay)
    }
    
    static func getStartAndEndOfWeek(for date: Date = Date()) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return nil }
        guard let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)?.addingTimeInterval(-1) else { return nil }
        return (start: startOfWeek, end: endOfWeek)
    }
    
    static func getStartAndEndOfMonth(for date: Date = Date()) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start else { return nil }
        guard let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-1) else { return nil }
        return (start: startOfMonth, end: endOfMonth)
    }
    
    static func getStartAndEndOfYear(for date: Date = Date()) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let startOfYear = calendar.dateInterval(of: .year, for: date)?.start else { return nil }
        guard let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)?.addingTimeInterval(-1) else { return nil }
        return (start: startOfYear, end: endOfYear)
    }
    
    static func getStartAndEnd(interval:String,date:Date = Date()) -> (start: Date, end: Date)? {
        switch interval {
        case "Daily":
            return DateCalculator.getStartAndEndOfDay(for: date)
        case "Weekly":
            return DateCalculator.getStartAndEndOfWeek(for: date)
        case "Monthly":
            return DateCalculator.getStartAndEndOfMonth(for: date)
        case "Annually":
            return DateCalculator.getStartAndEndOfYear(for: date)
        default:
            return DateCalculator.getStartAndEndOfDay(for: date)
        }
    }
}
