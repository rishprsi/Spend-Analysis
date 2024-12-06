//
//  ExpensesViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData
import SwiftUI

class ExpensesViewModel: ObservableObject {
//    @Environment(\.managedObjectContext) var moc
    @Published var newExpenseFlag: Bool = false // Default value
    @Published var newExpense: Expense = Expense(context: PersistenceController.shared.container.viewContext);
    @Published var expenses: [Expense] = [];
    @Published var categories: [Category] = [];
    private var currentOffset = 0
    private let fetchLimit = 40 // Number of items to load per scroll

    

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
//        cleanupInvalidEntries();
        fetchExpenses()
        fetchCategories()
        
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(saveChanges),
                    name: UIApplication.willResignActiveNotification,
                    object: nil
                )
    }
    
    func cleanupInvalidEntries() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == nil") // Find invalid entries

        do {
            let invalidExpenses = try context.fetch(request)
            for expense in invalidExpenses {
                context.delete(expense) // Delete invalid entries
            }
            try context.save() // Save changes
        } catch {
            print("Failed to clean up invalid entries: \(error)")
        }
    }
    
    func fetchCategories() {
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryRequest.propertiesToFetch = ["id","title"]
        categoryRequest.predicate = NSPredicate(format: "id != nil")
        do {
            self.categories = try context.fetch(categoryRequest)
            
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
    }
    
    func addExpense() {
        do {
            newExpense.id = UUID();
            newExpense.expenseDateTime = newExpense.expenseDateTime ?? Date();
            expenses.append(newExpense)
            try context.save() // Save the current newExpense to Core Data
//            fetchExpenses(offset: 0) // Refresh the expenses array to fetch fresh instances
            
            newExpense = Expense(context: context) // Reset newExpense with a new object
            newExpense.id = nil
            newExpense.title = ""
            newExpense.amount = 0.0
            newExpense.expenseDateTime = Date()
            newExpenseFlag = false
        } catch {
            print("Failed to save expense: \(error)")
        }
    }

    func fetchExpenses(offset: Int = 0, limit: Int? = nil) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id != nil")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.expenseDateTime, ascending: false)]
        request.fetchOffset = offset
        if let limit = limit {
            request.fetchLimit = limit
        }

        do {
            let newExpenses = try context.fetch(request)
            let existingExpenseIDs = Set(expenses.map { $0.id }) // Track existing expense IDs
            let uniqueNewExpenses = newExpenses.filter { !existingExpenseIDs.contains($0.id) } // Filter duplicates
            if uniqueNewExpenses.count > 0 {
                print("Fetched the expense: \(uniqueNewExpenses[uniqueNewExpenses.count-1].id) \(uniqueNewExpenses[uniqueNewExpenses.count-1].expenseDateTime)");
                expenses.append(contentsOf: uniqueNewExpenses)
            }
            
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
    }
        func loadMoreExpenses() {
            currentOffset += fetchLimit
            fetchExpenses(offset: currentOffset, limit: fetchLimit)
        }

    
    func toggleNewExpense() {
//        l
        newExpense.expenseDateTime = Date()
        newExpenseFlag.toggle();
        
    }
    
//    func deleteExpense(_ expense: Expense) {
//        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
//            expenses.remove(at: index)
//        }
//        context.delete(expense)
//        do{
//            try context.save()
//        }catch{
//            print("Failed to delete the category: \(error)")
//        }
//    }
    
    func deleteExpense(expenseToDelete: Expense) {
        // Find the index in the original expenses array
        if let index = expenses.firstIndex(where: { $0.id == expenseToDelete.id }) {
            // Remove from the array
            let expense = expenses.remove(at: index)

            // Remove from Core Data
            context.delete(expense)
            do {
                try context.save()
                print("Changes saved successfully.")
            } catch {
                print("Failed to save changes: \(error)")
            }
        }
    }
    @objc func saveChanges() {
            if context.hasChanges {
                do {
                    
                    try context.save()
                    print("Changes saved successfully.")
                } catch {
                    print("Failed to save changes: \(error)")
                }
            }
        }
}
