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

    var body: some View {
        // Form container for organizing the settings options.
        Form {
            Section(header: Text("Interval Preferences")) {
                // Picker for selecting budget interval.
                Picker("Budget Interval", selection: $viewModel.budgetInterval) {
                    // Define available options for the Picker.
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                    Text("Annually").tag("Annually")
                }
                .pickerStyle(SegmentedPickerStyle()) // Use segmented style for better visuals.
                .onChange(of: viewModel.budgetInterval) { _ in
                    // Save changes when the selection changes.
                    viewModel.saveSettings()
                }
                
                Picker("Visualization Interval", selection: $viewModel.visualizationInterval) {
                    // Define available options for the Picker.
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                    Text("Annually").tag("Annually")
                }
                .pickerStyle(SegmentedPickerStyle()) // Use segmented style for better visuals.
                .onChange(of: viewModel.budgetInterval) { _ in
                    // Save changes when the selection changes.
                    viewModel.saveSettings()
                }
                
                Picker("Summary Interval", selection: $viewModel.summaryInterval) {
                    // Define available options for the Picker.
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                    Text("Annually").tag("Annually")
                }
                .pickerStyle(SegmentedPickerStyle()) // Use segmented style for better visuals.
                .onChange(of: viewModel.budgetInterval) { _ in
                    // Save changes when the selection changes.
                    viewModel.saveSettings()
                }

                // Picker for selecting backup interval.
                Picker("Backup Interval", selection: $viewModel.backupInterval) {
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                    Text("Annually").tag("Annually")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.backupInterval) { _ in
                    viewModel.saveSettings()
                }
                
                // Picker for selecting backup type.
                Picker("Backup Type", selection: $viewModel.backupType) {
                    Text("Cloud").tag("Cloud")
                    Text("Local").tag("Local")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.backupType) { _ in
                    viewModel.saveSettings()
                }
            }
            
            Section(header: Text("Backup Preferences")) {
                
                // Picker for selecting backup type.
                Picker("Backup Type", selection: $viewModel.backupType) {
                    Text("Cloud").tag("Cloud")
                    Text("Local").tag("Local")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.backupType) { _ in
                    viewModel.saveSettings()
                }
                
                // Picker for selecting backup interval.
                Picker("Backup Interval", selection: $viewModel.backupInterval) {
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                    Text("Annually").tag("Annually")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.backupInterval) { _ in
                    viewModel.saveSettings()
                }
                
            }
        }
        .navigationTitle("Config") // Set the navigation title.
        .onAppear {
            viewModel.fetchSettings() // Fetch settings when the view appears.
        }
    }
}
