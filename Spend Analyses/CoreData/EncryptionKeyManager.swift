//
//  EncryptionKeyManager.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/12/24.
//

import CryptoKit
import SwiftUI

class EncryptionKeyManager {
    static func generateKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }

    static func saveKeyToKeychain(_ key: SymmetricKey, forKey keyIdentifier: String) {
        let keyData = key.withUnsafeBytes { Data($0) }
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyIdentifier,
            kSecValueData as String: keyData
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    static func loadKeyFromKeychain(forKey keyIdentifier: String) -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyIdentifier,
            kSecReturnData as String: true
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        if let keyData = result as? Data {
            return SymmetricKey(data: keyData)
        }
        return nil
    }
}
