//
//  Budget.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import SwiftUI

struct CategoryItem: Identifiable {
    let id = UUID()
    let title: String
    let budget: Float
    let expenses: [ExpenseItem] // Using AnyView for flexibility
    
    static func == (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(){
        title = ""
        budget = 0.0
        expenses = []
    }
}
