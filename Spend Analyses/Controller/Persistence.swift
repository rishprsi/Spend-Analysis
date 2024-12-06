    //
    //  Persistence.swift
    //  Spend Analyses
    //
    //  Created by Rishabh Pratap Singh on 26/10/24.
    //

    import CoreData

    struct PersistenceController {
        static let shared = PersistenceController()
        
        private let cache = NSCache<NSString, NSManagedObject>()

        @MainActor
        static let preview: PersistenceController = {
            let result = PersistenceController(inMemory: true)
            let viewContext = result.container.viewContext
            for _ in 0..<1 {
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return result
        }()

        let container: NSPersistentContainer

        init(inMemory: Bool = false) {
            container = NSPersistentContainer(name: "Spend_Analyses")
            if inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }else{
//                Provides encryption for data stored in persistent storage
                container.persistentStoreDescriptions.first!.setOption(FileProtectionType.complete as NSObject,
                                                                       forKey: NSPersistentStoreFileProtectionKey)
            }
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        
        // MARK: - Cache Management
            func getCachedObject(forKey key: String) -> NSManagedObject? {
                return cache.object(forKey: key as NSString)
            }

            func cacheObject(_ object: NSManagedObject, forKey key: String) {
                cache.setObject(object, forKey: key as NSString)
            }

            func removeCachedObject(forKey key: String) {
                cache.removeObject(forKey: key as NSString)
            }
    }
