//
//  FetchExpensesBetweenDates.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 04/12/24.
//
import SwiftUI
import CoreData
struct FetchExpensesBetweenDates {
    static func getExpenses(startDate:Date, endDate:Date) -> [Expense]{
        print("Start Date and End Date are: \(startDate) and \(endDate)")
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicate = NSPredicate(format: "expenseDateTime >= %@ AND expenseDateTime <= %@", startDate as NSDate, endDate as NSDate)
        request.predicate = predicate
        var expenses:[Expense] = []
        do {
            expenses = try PersistenceController.shared.container.viewContext.fetch(request)
            print("Expenses between \(startDate) and \(endDate): \(expenses)")
        } catch {

            print("Error fetching expenses: \(error)")
        }
        return expenses
    }
}
