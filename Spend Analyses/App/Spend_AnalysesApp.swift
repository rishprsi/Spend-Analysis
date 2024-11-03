//
//  Spend_AnalysesApp.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

@main
struct Spend_AnalysesApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var expensesViewModel = ExpensesViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(expensesViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

}
