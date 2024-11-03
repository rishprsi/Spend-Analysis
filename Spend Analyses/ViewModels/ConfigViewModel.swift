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

    private var context: NSManagedObjectContext
    
    init() {
        context = PersistenceController.shared.container.viewContext
        fetchConfig()
    }
    
    func fetchConfig() {
        let request: NSFetchRequest<Config> = Config.fetchRequest()
        
        do {
            let settings = try context.fetch(request)
            if let savedSetting = settings.first {
                budgetInterval = savedSetting.budgetInterval ?? "Weekly"
                visualizationInterval = savedSetting.budgetInterval ?? "Weekly"
                summaryInterval = savedSetting.budgetInterval ?? "Weekly"
                backupInterval = savedSetting.backupInterval ?? "Weekly"
                backupType = savedSetting.backupType ?? "Cloud"
            }
        } catch {
            print("Failed to fetch settings: \(error)")
        }
    }
    
    func saveSettings() {
        let request: NSFetchRequest<Config> = Config.fetchRequest()
        
        do {
            let configs = try context.fetch(request)
            let config = configs.first ?? Config(context: context) // Create if it doesn't exist
            
            config.budgetInterval = budgetInterval
            config.budgetInterval = budgetInterval
            config.budgetInterval = budgetInterval
            config.backupInterval = backupInterval
            config.backupType = backupType
            
            try context.save()
        } catch {
            print("Failed to save settings: \(error)")
        }
    }
}

