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
    @Published var newExpense: Expense = Expense(context: PersistenceController.shared.container.viewContext)
    @Published var expenses: [Expense] = [];
    @Published var categories: [Category] = [];
    private var currentOffset = 0
    private let fetchLimit = 40 // Number of items to load per scroll

    

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchExpenses()
        fetchCategories()
        
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(saveChanges),
                    name: UIApplication.willResignActiveNotification,
                    object: nil
                )
    }
    
    func fetchCategories() {
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryRequest.propertiesToFetch = ["id","title"]
        do {
            self.categories = try context.fetch(categoryRequest)
            
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
    }
    
    func addExpense(){
        
    }
    
    func fetchExpenses(offset: Int = 0, limit: Int? = nil) {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.expenseDateTime, ascending: false)]
            request.fetchOffset = offset
            if let limit = limit {
                request.fetchLimit = limit
            }

            do {
                let newExpenses = try context.fetch(request)
                if offset == 0 {
                    expenses = newExpenses
                } else {
                    expenses.append(contentsOf: newExpenses)
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
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenses = try context.fetch(request)
            newExpenseFlag = !newExpenseFlag
        } catch {
            print("Failed to save expenses: \(error)")
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
