//
//  ConfigViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData

class BudgetViewModel: ObservableObject {
    @Published var newCategoryFlag: Bool = false
    @Published var categories: [Category] = []
    @Published var newCategory: Category
    @Published var budgetInterval: String = "Weekly";
    @Published var currentExpenses: [Expense] = [];
    @Published var totalBudget: Float = 0.0;
    @Published var expandedCategory: UUID?
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        
        self.context = context
        self.newCategory = Category(context: context)
        self.newCategory.id = nil;
        self.newCategory.title = ""
        self.newCategory.budget = 0.0
//        cleanupInvalidEntries()
        fetchCategories()
        currentExpenses = fetchExpensesForInterval()
        
    }

    func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let configRequest: NSFetchRequest<Config> = Config.fetchRequest()
        
        request.predicate = NSPredicate(format: "id != nil")
        do {
            let settings = try context.fetch(configRequest);
             if let savedSetting = settings.first{
                 budgetInterval = savedSetting.budgetInterval ?? "Weekly"
                 totalBudget = savedSetting.totalBudget;
            }
            categories = try context.fetch(request)
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func fetchExpensesForInterval() -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        let calendar = Calendar.current
        let now = Date()

        // Determine the start date based on the budgetInterval
        let startDate: Date?
        let endDate: Date?
        switch budgetInterval {
        case "Weekly":
            (startDate,endDate) = DateCalculator.getStartAndEndOfWeek(for: now)!
//            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))
        case "Monthly":
            (startDate,endDate) = DateCalculator.getStartAndEndOfMonth(for: now)!
//            startDate = calendar.date(byAdding: .month, value: -1, to: now)
        case "Daily":
            (startDate,endDate) = DateCalculator.getStartAndEndOfDay(for: now)!
//            startDate = Calendar.current.startOfDay(for: Date())
        default:
            startDate = nil
            endDate = nil
        }

        // Apply date range predicate if startDate is valid
//        if let startDate = startDate {
//
////            request.predicate = NSPredicate(format: "expenseDateTime >= %@", startDate as NSDate)
//        } else {
//            request.predicate = nil // No filtering if interval is invalid
//        }

        do {
            return FetchExpensesBetweenDates.getExpenses(startDate: startDate!, endDate: endDate!);
//            return try context.fetch(request)
        } catch {
            print("Failed to fetch expenses for \(budgetInterval): \(error)")
            return []
        }
    }

    func cleanupInvalidEntries() {
        print("Budget value being set is ")
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let configRequest: NSFetchRequest<Config> = Config.fetchRequest()
        request.predicate = NSPredicate(format: "id == nil")

        do {
            let configs = try context.fetch(configRequest)
            let config = configs.first ?? Config(context: context)
            config.totalBudget = categories.reduce(0){$0 + $1.budget }
            print("Budget value being set is \(config.totalBudget)")
            let invalidCategories = try context.fetch(request)
            for category in invalidCategories {
                context.delete(category)
            }
            try context.save()
        } catch {
            print("Failed to clean up invalid entries: \(error)")
        }
    }

    func addCategory() {
        print("Saving Category: \(newCategory.title), \(newCategory.budget)")

        do {
            newCategory.id = UUID();
            categories.append(newCategory)
            try context.save()
            
            print("Category saved: \(newCategory.title), \(newCategory.budget)")
        } catch {
            print("Failed to save the category: \(error)")
        }

        newCategory = Category(context: context)
        newCategory.id = nil
        newCategory.title = ""
        newCategory.budget = 0.0
        newCategoryFlag = false
    }

    func toggleNewCategory() {
        newCategoryFlag.toggle()
    }
    
    func deleteCategory(_ category: Category) {
        // Delete category from the data source
       
            if let index = categories.firstIndex(where: { $0.id == category.id }) {
                categories.remove(at: index)
            }
            context.delete(category)
        do{
            try context.save()
        }catch{
            print("Failed to delete the category: \(error)")
        }
        
        // Update Core Data or your persistent storage as needed
        // Example: context.delete(category)
    }
    func updateCategory(_ updatedCategory: Category) {
        if let index = categories.firstIndex(where: { $0.id == updatedCategory.id }) {
            categories[index] = updatedCategory
            
            do{
                try context.save()
            }catch{
                print("Failed to update the category: \(error)")
            }
            expandedCategory = nil
            // Update Core Data or persistent storage as needed
            // Example:
            // try? context.save()
        }
    }

//    func editCategory(_ category: Category) {
//        // Set the category being edited
//        self.selectedCategory = category
//        self.isEditingCategory = true
//    }
}
