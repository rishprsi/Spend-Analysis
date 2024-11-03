//
//  BottomNavViewModel.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI
import Combine

class BottomNavViewModel: ObservableObject {
    @Published var selectedTab: NavigationItem
    
    var items: [NavigationItem] = [
        NavigationItem(title: "Home", icon: "house", view: AnyView(HomeView())),
        NavigationItem(title: "Expenses", icon: "dollarsign.circle", view: AnyView(ExpensesView())),
        NavigationItem(title: "Budget", icon: "chart.pie", view: AnyView(BudgetView())),
        NavigationItem(title: "Visualisation", icon: "chart.line.uptrend.xyaxis", view: AnyView(VisualizationView())),
        NavigationItem(title: "Config", icon: "gear", view: AnyView(ConfigView()))
    ]
    
    init() {
        selectedTab = items[0] // Default selection
    }
}
