//
//  VisualizationViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/12/24.
//

import Foundation
import Charts
import CoreData

class VisualizationViewModel: ObservableObject {
    
    @Published var expenses: [Expense] = []
    @Published var totalExpensesByInterval: [(String, Float)] = []
    @Published var categoryExpenses: [(String, Float)] = []
    @Published var visualizationInterval: String = "Weekly"
    @Published var chartType: String = "Line"
    @Published var selectedDate: Date = Date()

    private var calendar = Calendar.current
    private var context: NSManagedObjectContext

    init() {
//        self.expenses = expenses
//        self.budgetInterval = budgetInterval
        context = PersistenceController.shared.container.viewContext
        fetchVisualizationInterval()
        let (startDate,endDate) = DateCalculator.getStartAndEnd(interval: visualizationInterval,date: Date())!
        expenses = FetchExpensesBetweenDates.getExpenses(startDate: startDate, endDate: endDate)
        calculateTotalExpensesByInterval()
        calculateCategoryExpenses()
        
    }
    
    func fetchVisualizationInterval() {
        let request: NSFetchRequest<Config> = Config.fetchRequest()
        do {
            let settings = try context.fetch(request)
            if let savedSetting = settings.first {
                visualizationInterval = savedSetting.visualizationInterval ?? "Weekly"}
            
        }
        catch{
            print("Failed to fetch visualization interval")
        }
    }

    func calculateTotalExpensesByInterval() {
        totalExpensesByInterval = []

        let intervalComponent: Calendar.Component
        let labelFormatter = DateFormatter()

        switch visualizationInterval {
        case "Weekly":
            intervalComponent = .day
            labelFormatter.dateFormat = "MMM d" // e.g., "Jan 1"
        case "Monthly":
            intervalComponent = .weekOfMonth
            labelFormatter.dateFormat = "d" // e.g., "Jan 1 - Jan 7"
        case "Annually":
            intervalComponent = .month
            labelFormatter.dateFormat = "MMM" // e.g., "Jan"
        default:
            return
        }

        // Get the start and end dates for the visualization interval
        guard let (currentStartDate, endDate) = DateCalculator.getStartAndEnd(interval: visualizationInterval, date: selectedDate) else {
            return
        }

        var currentDate = currentStartDate

        while currentDate <= endDate {
            // Calculate the next interval's start date
            let nextDate = calendar.date(byAdding: intervalComponent, value: 1, to: currentDate)!

            // Filter expenses for the current interval
            let intervalExpenses = expenses.filter {
                let expenseDate = $0.expenseDateTime
                return expenseDate >= currentDate && expenseDate < nextDate
            }

            // Calculate the total for the interval
            let total = intervalExpenses.reduce(0) { $0 + $1.amount }

            // Create labels for the intervals
            let label: String
            switch visualizationInterval {
            case "Weekly":
                label = labelFormatter.string(from: currentDate)
            case "Monthly":
                let firstDate = labelFormatter.string(from: currentDate)
                let lastDate = labelFormatter.string(from: calendar.date(byAdding: .day, value: -1, to: nextDate)!)
                label = "\(firstDate) - \(lastDate)"
            case "Annually":
                label = labelFormatter.string(from: currentDate)
            default:
                label = ""
            }

            // Append the result to the interval list
            totalExpensesByInterval.append((label: label, total: total))

            // Move to the next interval
            currentDate = nextDate
        }
    }



    func calculateCategoryExpenses() {
        let groupedExpenses = Dictionary(grouping: expenses, by: { $0.category?.title ?? "Uncategorized" })

        categoryExpenses = groupedExpenses.map { (category, expenses) in
            let total = expenses.reduce(0) { $0 + $1.amount }
            return (category, total)
        }

        // Sort by amount for better visualization
        categoryExpenses.sort { $0.1 > $1.1 }
    }
}
