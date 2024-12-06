//
//  CoreDataBackupManager.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/12/24.
//

import CoreData
import CryptoKit
import Foundation

class CoreDataBackupManager {
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    // Backup Core Data
    func backupCoreData(to destinationURL: URL, encryptionKey: SymmetricKey) throws {
        // Step 1: Get Core Data store URL
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            throw NSError(domain: "CoreDataBackup", code: 1, userInfo: [NSLocalizedDescriptionKey: "No store URL found"])
        }

        // Step 2: Copy the SQLite store file
        let fileManager = FileManager.default
        let tempBackupURL = destinationURL.appendingPathExtension("temp")

        try fileManager.copyItem(at: storeURL, to: tempBackupURL)

        // Step 3: Encrypt the copied file
        let fileData = try Data(contentsOf: tempBackupURL)
        let sealedData = try AES.GCM.seal(fileData, using: encryptionKey)

        // Step 4: Save encrypted data
        let encryptedData = sealedData.combined
        try encryptedData?.write(to: destinationURL)

        // Step 5: Remove temp file
        try fileManager.removeItem(at: tempBackupURL)
    }
    
    
    func restoreCoreData(from sourceURL: URL, encryptionKey: SymmetricKey) throws {
        // Step 1: Read encrypted file
        let encryptedData = try Data(contentsOf: sourceURL)

        // Step 2: Decrypt the data
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        // Step 3: Write decrypted data to Core Data store
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            throw NSError(domain: "CoreDataRestore", code: 2, userInfo: [NSLocalizedDescriptionKey: "No store URL found"])
        }

        try decryptedData.write(to: storeURL)
    }
}
