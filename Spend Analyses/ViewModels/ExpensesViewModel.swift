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
    

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchExpenses()
        fetchCategories()
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
    
    func fetchExpenses() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest();
        
        
        do {
            expenses = try context.fetch(request)
            
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
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
}
