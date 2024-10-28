//
//  ExpensesViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData

class ExpensesViewModel: ObservableObject {
    @Published var newExpense: Bool = false // Default value

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchExpenses()
    }
    
    func fetchExpenses() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest();
        
        do {
            let expenses = try context.fetch(request)
            
        } catch {
            print("Failed to fetch expenses: \(error)")
        }
    }
    
    func toggleNewCategory() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let categories = try context.fetch(request)
            newExpense = !newExpense
        } catch {
            print("Failed to save expenses: \(error)")
        }
    }
}
