//
//  HomeViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//
import SwiftUI
import CoreData

class HomeViewModel: ObservableObject {
    @Published var selectedStartDate: Date? // Start date of the selection
    @Published var selectedEndDate: Date?   // End date of the selection
    @Published var currentMonth: Date = Date() // The month being displayed
    @Published var currentMonthExpenses: Float = 0.0
    @Published var selectedRangeExpenses: Float = 0.0
    @Published var totalBudget: Float = 0.0
    @Published var budgetInterval: String = "Weekly"
    
    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchTotalBudget()
    }
        
    func fetchTotalBudget() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let configRequest: NSFetchRequest<Config> = Config.fetchRequest()
        
        request.predicate = NSPredicate(format: "id != nil")
        do {
            let settings = try context.fetch(configRequest);
             if let savedSetting = settings.first{
                 budgetInterval = savedSetting.budgetInterval ?? "Weekly"
                 totalBudget = savedSetting.totalBudget;
            }
            
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
        var daysInCurrentMonth: [Int] {
            let range = Calendar.current.range(of: .day, in: .month, for: currentMonth) ?? 0..<0
            return Array(range)
        }

        var monthName: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yy"
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
            guard let start = selectedStartDate else {
                
                return false
            }
        if (day==Calendar.current.component(.day, from: selectedStartDate!) && month(from:currentMonth)==month(from:selectedStartDate!) && year(from:currentMonth)==year(from:selectedStartDate!)){
                return true
            }
            guard let end = selectedEndDate else {
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
    
    // Total expenses for the current month
        func monthlyExpenses() -> Float {
            let (startDate,endDate) = DateCalculator.getStartAndEndOfMonth(for: currentMonth)!
            
            return FetchExpensesBetweenDates.getExpenses(startDate: startDate, endDate: endDate)
            .reduce(0) { $0 + $1.amount }
        }
    
    func monthlyRangeBudget() -> Float {
        let currMonth = Calendar.current.component(.month, from: currentMonth)
        let days = Calendar.current.range(of: .day, in: .month, for: currentMonth)!
        if (budgetInterval == "Daily"){
            return Float(days.count) * totalBudget
        }else if (budgetInterval == "Weekly") {
            return Float(days.count)/7.0 * totalBudget
        }else{
            return totalBudget
        }
    }
    
    func spendingForSelectedRange() -> Float {
        let startDate:Date;
        if selectedStartDate == nil {
            startDate = Calendar.current.startOfDay(for: Date())
            
        }else{
            startDate = selectedStartDate!
        }
            var endDate = selectedEndDate ?? startDate
        endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        
            return FetchExpensesBetweenDates.getExpenses(startDate: startDate, endDate: endDate).reduce(0) { $0 + $1.amount }
        }
    
    func selectedRangeBudget() -> Float {
        let startDate:Date;
        if selectedStartDate == nil {
            startDate = Calendar.current.startOfDay(for: Date())
            
        }else{
            startDate = selectedStartDate!
        }
            var endDate = selectedEndDate ?? startDate
        endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        return budgetInInterval(startDate: startDate, endDate: endDate, totalBudget: totalBudget, budgetInterval: budgetInterval)
    }
    
    func selectedRangeTitle() -> String {
            if let startDate = selectedStartDate, let endDate = selectedEndDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                return "\(formatter.string(from: startDate))-\(formatter.string(from: endDate))"
            } else {
                let startDate:Date;
                if selectedStartDate == nil {
                    startDate = Date()
                }else{
                    startDate = selectedStartDate!
                }
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter.string(from: startDate)
            }        }

}

