//
//  HomeViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedDate = Date() // The currently selected date
    @Published var currentMonth = Date() // The current month to display

    var daysInCurrentMonth: [Int] {
        let range = Calendar.current.range(of: .day, in: .month, for: currentMonth) ?? 0..<0
        return Array(range)
    }

    // Month names for display
    var monthNames: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return (1...12).map { formatter.string(from: Calendar.current.date(from: DateComponents(month: $0))!) }
    }

    // Year range for selection
    var availableYears: [Int] {
        return Array(2020...2030) // Example range, modify as needed
    }

    func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? Date()
    }

    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? Date()
    }

    func isSelected(day: Int) -> Bool {
        let dateToCheck = Calendar.current.date(from: DateComponents(year: year(from: currentMonth), month: month(from: currentMonth), day: day)) ?? Date()
        return Calendar.current.isDate(dateToCheck, inSameDayAs: selectedDate)
    }

    func month(from date: Date) -> Int {
        return Calendar.current.component(.month, from: date)
    }

    func year(from date: Date) -> Int {
        return Calendar.current.component(.year, from: date)
    }

    func changeYear(to year: Int) {
        if let newDate = Calendar.current.date(bySetting: .year, value: year, of: currentMonth) {
            currentMonth = newDate
        }
    }

    func changeMonth(to month: Int) {
        if let newDate = Calendar.current.date(bySetting: .month, value: month, of: currentMonth) {
            currentMonth = newDate
        }
    }
}

