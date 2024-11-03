//
//  HomeViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedStartDate: Date? // Start date of the selection
        @Published var selectedEndDate: Date?   // End date of the selection
        @Published var currentMonth: Date = Date() // The month being displayed
        
        var daysInCurrentMonth: [Int] {
            let range = Calendar.current.range(of: .day, in: .month, for: currentMonth) ?? 0..<0
            return Array(range)
        }

        var monthName: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: currentMonth)
        }

        func nextMonth() {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? Date()
        }

        func previousMonth() {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? Date()
        }

        func selectDate(_ date: Date) {
            if selectedStartDate == nil {
                selectedStartDate = date
            } else if selectedEndDate == nil {
                if date < selectedStartDate! {
                    selectedEndDate = selectedStartDate
                    selectedStartDate = date
                } else {
                    selectedEndDate = date
                }
            } else {
                selectedStartDate = date
                selectedEndDate = nil
            }
        }
        
        func isSelected(day: Int) -> Bool {
            guard let start = selectedStartDate, let end = selectedEndDate else {
                return false
            }
            let dateToCheck = Calendar.current.date(from: DateComponents(year: year(from: currentMonth), month: month(from: currentMonth), day: day)) ?? Date()
            return (dateToCheck >= start && dateToCheck <= end)
        }
        
        func month(from date: Date) -> Int {
            return Calendar.current.component(.month, from: date)
        }

        func year(from date: Date) -> Int {
            return Calendar.current.component(.year, from: date)
        }
}

