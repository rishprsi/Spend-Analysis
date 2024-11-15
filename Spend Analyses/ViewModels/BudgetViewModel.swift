//
//  ConfigViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData

class BudgetViewModel: ObservableObject {
    @Published var newCategoryFlag: Bool = false // Default value
    @Published var categories: [Category] = [];
    @Published var newCategory: Category = Category(context: PersistenceController.shared.container.viewContext)

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchCategories()
    }
    
    func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest();
        
        do {
            categories = try context.fetch(request)
            
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func toggleNewCategory() {
        do {
            newCategoryFlag = !newCategoryFlag
        } catch {
            print("Failed to save categories: \(error)")
        }
    }
}


