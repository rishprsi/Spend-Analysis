//
//  FileExportManager.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/12/24.
//

import UIKit
import SwiftUI

class FileExportManager: NSObject, ObservableObject, UIDocumentPickerDelegate {
    @Published var exportCompletionMessage: String?

    func exportEncryptedBackup(fileURL: URL, from presentingViewController: UIViewController) {
        let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
        documentPicker.delegate = self
        presentingViewController.present(documentPicker, animated: true, completion: nil)
    }
    
    // Import encrypted backup
        func importEncryptedBackup(from presentingViewController: UIViewController) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
            documentPicker.delegate = self
            presentingViewController.present(documentPicker, animated: true, completion: nil)
        }

    // UIDocumentPickerDelegate methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            exportCompletionMessage = "Export canceled or no location selected."
            return
        }
        exportCompletionMessage = "File saved successfully to \(selectedURL.path)"
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        exportCompletionMessage = "Export canceled by user."
    }
    
    var onFileSelected: ((URL) -> Void)?
}
