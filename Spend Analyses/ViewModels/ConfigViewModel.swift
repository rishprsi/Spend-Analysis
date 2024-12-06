//
//  ConfigViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import Foundation
import CoreData
import UniformTypeIdentifiers
import UIKit

class ConfigViewModel: ObservableObject {
    @Published var budgetInterval: String = "Weekly" // Default value
    @Published var visualizationInterval: String = "Weekly" // Default value
    @Published var summaryInterval: String = "Weekly" // Default value
    @Published var backupInterval: String = "Weekly" // Default value
    @Published var backupType: String = "Local" // Default value
    @Published var totalBudget: Float = 0.0
    @Published var selectedFileURL: URL?
    @Published var showFilePicker = false
    @Published var isPermissionDenied = false
    @Published var showBackupSuccess = false
    @Published var resultMessage = ""
    @Published var showOperationResult = false
    
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
    
//    func checkPermissionsAndShowPicker() {
//            let fileManager = FileManager.default
//            let tempDirectory = fileManager.temporaryDirectory
//
//            do {
//                _ = try fileManager.contentsOfDirectory(atPath: tempDirectory.path)
//                showFilePicker = true // Permission granted
//            } catch {
//                isPermissionDenied = true // Permission denied
//            }
//        }
//
//        func openSettings() {
//            if let url = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(url)
//            }
//        }
    
    func createAndExportBackup(fileExportManager:FileExportManager) {
            // Create backup file
            let backupURL = FileManager.default.temporaryDirectory.appendingPathComponent("CoreDataBackup.enc")
            let encryptionKey = EncryptionKeyManager.generateKey() // Generate or retrieve your encryption key
        let backupManager = CoreDataBackupManager(persistentContainer: PersistenceController.shared.container)

            do {
                // Backup Core Data
                try backupManager.backupCoreData(to: backupURL, encryptionKey: encryptionKey)

                // Present save dialog to user
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            fileExportManager.exportEncryptedBackup(fileURL: backupURL, from: rootVC)
                        }
                resultMessage = "Encryption Key: \(encryptionKey)"
            } catch {
                resultMessage = "Backup failed: \(error.localizedDescription)"
                fileExportManager.exportCompletionMessage = "Backup failed: \(error.localizedDescription)"
                showBackupSuccess = true
            }
        }
    func selectBackupFileForRestore(fileExportManager:FileExportManager) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                fileExportManager.onFileSelected = { fileURL in
                    self.restoreBackup(from: fileURL)
                }
                fileExportManager.importEncryptedBackup(from: rootVC)
            }
        }
        
        private func restoreBackup(from fileURL: URL) {
            let backupManager = CoreDataBackupManager(persistentContainer: PersistenceController.shared.container)
            
            do {
                try backupManager.restoreCoreData(from: fileURL, encryptionKey: EncryptionKeyManager.generateKey())
                resultMessage = "Restore successful!"
            } catch {
                resultMessage = "Restore failed: \(error.localizedDescription)"
            }
            showOperationResult = true
        }
}

