//
//  ConfigViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData

class ConfigViewModel: ObservableObject {
    @Published var budgetInterval: String = "Weekly" // Default value
    @Published var visualizationInterval: String = "Weekly" // Default value
    @Published var summaryInterval: String = "Weekly" // Default value
    @Published var backupInterval: String = "Weekly" // Default value
    @Published var backupType: String = "Cloud" // Default value
    @Published var totalBudget: Float = 0.0
    
    var categories :[Category] = []
    
    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchConfig()
        fetchCategories()
    }
    
    func fetchConfig() {
        let request: NSFetchRequest<Config> = Config.fetchRequest()
        
        do {
            let settings = try context.fetch(request)
            if let savedSetting = settings.first {
                budgetInterval = savedSetting.budgetInterval ?? "Weekly"
                visualizationInterval = savedSetting.visualizationInterval ?? "Weekly"
                summaryInterval = savedSetting.summaryInterval ?? "Weekly"
                backupInterval = savedSetting.backupInterval ?? "Weekly"
                backupType = savedSetting.backupType ?? "Cloud"
                totalBudget = savedSetting.totalBudget
            }
        } catch {
            print("Failed to fetch settings: \(error)")
        }
    }
    
    func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "id != nil")
        do {
             
            categories = try context.fetch(request)
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func changeBudgets(newInterval: String) {
        if (newInterval != budgetInterval){
            var modifier:Float = 1.0;
            switch newInterval {
            case "Daily":
                if (budgetInterval=="Weekly"){
                    modifier = 1.0/7.0
                }else if(budgetInterval=="Monthly"){
                    modifier = 1.0/30.0
                }
            case "Weekly":
                if (budgetInterval=="Daily"){
                    modifier = 7.0
                }else if(budgetInterval=="Monthly"){
                    modifier = 7.0/30.0
                }
            case "Monthly":
                if (budgetInterval == "Daily"){
                    modifier = 30.0
                }else if(budgetInterval == "Weekly"){
                    modifier = 30.0/7.0
                }
            default :
                break
            }
            
            for index in categories.indices {
                categories[index].budget *= modifier
            }
        }
    }
    
    func saveSettings() {
        let request: NSFetchRequest<Config> = Config.fetchRequest()
        
        do {
            let configs = try context.fetch(request)
            let config = configs.first ?? Config(context: context) // Create if it doesn't exist
            
            config.budgetInterval = budgetInterval
            config.visualizationInterval = visualizationInterval
            config.summaryInterval = summaryInterval
            config.backupInterval = backupInterval
            config.backupType = backupType
            
            try context.save()
        } catch {
            print("Failed to save settings: \(error)")
        }
    }
}

