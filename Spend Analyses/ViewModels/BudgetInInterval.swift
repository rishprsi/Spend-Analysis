//
//  BudgetInInterval.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 02/12/24.
//

import SwiftUI

func budgetInInterval(
    startDate: Date,
    endDate: Date,
    totalBudget: Float,
    budgetInterval: String
) -> Float {
    let calendar = Calendar.current
    let start = min(startDate, endDate) // Ensure the start date is earlier
    let end = max(startDate, endDate)  // Ensure the end date is later

    var totalBudgetForRange: Float = 0.0

    switch budgetInterval {
    case "Daily":
        // Budget per day
        let dailyBudget = totalBudget
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        totalBudgetForRange = Float(days + 1) * dailyBudget

    case "Weekly":
        // Budget per week
        let weeklyBudget = totalBudget
        var currentStart = start
        
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        let fraction:Float = Float(days+1) / 7.0
        totalBudgetForRange = fraction * weeklyBudget;

    case "Monthly":
        // Budget per month
        let monthlyBudget = totalBudget
        var currentStart = start

        while currentStart <= end {
            let monthEnd = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: calendar.date(from: calendar.dateComponents([.year, .month], from: currentStart))!
            ) ?? currentStart

            let intervalEnd = min(monthEnd, end) // End of the range or month
            let daysInMonth = calendar.range(of: .day, in: .month, for: currentStart)?.count ?? 30
            let daysInRange = calendar.dateComponents([.day], from: currentStart, to: intervalEnd).day ?? 0

            let fraction = Float(daysInRange) / Float(daysInMonth) // Fraction of the month
            totalBudgetForRange += monthlyBudget * fraction

            currentStart = calendar.date(byAdding: .day, value: daysInRange + 1, to: currentStart) ?? currentStart
        }
 
    default:
        print("Invalid budget interval")
    }

    return totalBudgetForRange
}
