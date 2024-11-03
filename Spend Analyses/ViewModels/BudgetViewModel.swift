//
//  ConfigViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData

class BudgetViewModel: ObservableObject {
    @Published var newCategory: Bool = false // Default value

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchCategories()
    }
    
    func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest();
        
        do {
            let categories = try context.fetch(request)
            
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func toggleNewCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try context.fetch(request)
            newCategory = !newCategory
        } catch {
            print("Failed to save categories: \(error)")
        }
    }
}


