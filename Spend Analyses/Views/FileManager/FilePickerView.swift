//
//  FilePickerView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/12/24.
//
import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?
    @Binding var showPicker: Bool

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data]) // `.data` for all files
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerView

        init(_ parent: FilePickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFileURL = urls.first
            parent.showPicker = false
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.showPicker = false
        }
    }
}
