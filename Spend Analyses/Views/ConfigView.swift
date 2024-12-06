//
//  ConfigView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

// The settings view displaying options for user preferences.
struct ConfigView: View {
    // Create an instance of the ViewModel.
    @StateObject private var viewModel = ConfigViewModel()
    @StateObject private var fileExportManager = FileExportManager()
    
    
    var body: some View {
        // Form container for organizing the settings options.
        Form {
            Section(header: Text("Interval Preferences")) {
                // Picker for selecting budget interval.
                HStack {
                    Text("Budget Interval")
                    Spacer()
                    Menu {
                        // Define dropdown options for budget interval
                        Button(action: {
                            viewModel.changeBudgets(newInterval: "Daily")
                            viewModel.budgetInterval = "Daily"
                            viewModel.saveSettings()
                        }) {
                            Text("Daily")
                        }
                        Button(action: {
                            viewModel.changeBudgets(newInterval: "Weekly" )
                            viewModel.budgetInterval = "Weekly"
                            viewModel.saveSettings()
                        }) {
                            Text("Weekly")
                        }
                        Button(action: {
                            viewModel.changeBudgets(newInterval: "Monthly" )
                            viewModel.budgetInterval = "Monthly"
                            viewModel.saveSettings()
                        }) {
                            Text("Monthly")
                        }
                        
                    } label: {
                        // Display the current selection
                        Text(viewModel.budgetInterval)
                            .foregroundColor(.primary)
                    }
                }
                
                HStack {
                    Text("Visualization Interval")
                    Spacer()
                    Menu {
                        // Define dropdown options for budget interval
                        Button(action: {
                            viewModel.visualizationInterval = "Weekly"
                            viewModel.saveSettings()
                        }) {
                            Text("Weekly")
                        }
                        Button(action: {
                            viewModel.visualizationInterval = "Monthly"
                            viewModel.saveSettings()
                        }) {
                            Text("Monthly")
                        }
                        Button(action: {
                            viewModel.visualizationInterval = "Annually"
                            viewModel.saveSettings()
                        }) {
                            Text("Annually")
                        }
                    } label: {
                        // Display the current selection
                        Text(viewModel.visualizationInterval)
                            .foregroundColor(.primary)
                    }
                }
                
                HStack {
                    Text("Summary Interval")
                    Spacer()
                    Menu {
                        // Define dropdown options for budget interval
                        Button(action: {
                            viewModel.summaryInterval = "Weekly"
                            viewModel.saveSettings()
                        }) {
                            Text("Weekly")
                        }
                        Button(action: {
                            viewModel.summaryInterval = "Monthly"
                            viewModel.saveSettings()
                        }) {
                            Text("Monthly")
                        }
                        Button(action: {
                            viewModel.summaryInterval = "Annually"
                            viewModel.saveSettings()
                        }) {
                            Text("Annually")
                        }
                    } label: {
                        // Display the current selection
                        Text(viewModel.summaryInterval)
                            .foregroundColor(.primary)
                    }
                }
                
                
            }
            
            Section(header: Text("Backup Preferences")) {
                
                // Picker for selecting backup type.
                HStack {
                    Text("Backup Type")
                    Spacer()
                    Menu {
                        // Define dropdown options for budget interval
                        Button(action: {
                            viewModel.backupType = "Cloud"
                            viewModel.saveSettings()
                        }) {
                            Text("Cloud")
                        }
                        Button(action: {
                            viewModel.backupType = "Local"
                            viewModel.saveSettings()
                        }) {
                            Text("Local")
                        }
                        
                    } label: {
                        // Display the current selection
                        Text(viewModel.backupType)
                            .foregroundColor(.primary)
                    }
                }
                
                // Picker for selecting backup interval.
                HStack {
                    Text("Backup Interval")
                    Spacer()
                    Menu {
                        // Define dropdown options for budget interval
                        Button(action: {
                            viewModel.backupInterval = "Weekly"
                            viewModel.saveSettings()
                        }) {
                            Text("Weekly")
                        }
                        Button(action: {
                            viewModel.backupInterval = "Monthly"
                            viewModel.saveSettings()
                        }) {
                            Text("Monthly")
                        }
                        Button(action: {
                            viewModel.backupInterval = "Annually"
                            viewModel.saveSettings()
                        }) {
                            Text("Annually")
                        }
                    } label: {
                        // Display the current selection
                        Text(viewModel.backupInterval)
                            .foregroundColor(.primary)
                    }
                }
                Button(action: {
                    viewModel.createAndExportBackup(fileExportManager: fileExportManager)
                }) {
                    Text("Run Backup")
                        .frame(maxWidth: .infinity,alignment: .leading) // Expand to fill space
                        .background(.white) // Button background
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
                .alert(isPresented: $viewModel.showBackupSuccess) {
                                Alert(
                                    title: Text("Backup Status"),
                                    message: Text(fileExportManager.exportCompletionMessage ?? "Unknown"),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                
                Button(action: {
                    viewModel.selectBackupFileForRestore(fileExportManager: fileExportManager)
                }) {
                    Text("Restore Backup")
                        .frame(maxWidth: .infinity, alignment: .leading) // Expand to fill space
                        .background(.white) // Button background
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
                
                .sheet(isPresented: $viewModel.showFilePicker) {
                            FilePickerView(selectedFileURL: $viewModel.selectedFileURL, showPicker: $viewModel.showFilePicker)
                }            }.alert(isPresented: $viewModel.showOperationResult) {
                            Alert(
                                title: Text("Operation Result"),
                                message: Text(viewModel.resultMessage),
                                dismissButton: .default(Text("OK"))
                            )
                        }
        }
        .navigationTitle("Config") // Set the navigation title.
        .onAppear {
            viewModel.fetchConfig() // Fetch settings when the view appears.
        }
    }
    
}
