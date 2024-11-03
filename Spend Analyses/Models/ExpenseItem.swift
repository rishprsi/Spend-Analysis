//
//  Expense.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 27/10/24.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    let id = UUID()
    let title: String
    let category: CategoryItem
    let amount: Float
    let expenseDateTime: Date
    let type: String // Using AnyView for flexibility
    
    static func == (lhs: ExpenseItem, rhs: ExpenseItem) -> Bool {
            return lhs.id == rhs.id
        }
    
    init(){
        self.title = ""
        self.amount = 0.0
        self.expenseDateTime = Date()
        self.type = "One Time"
        
        self.category = CategoryItem()
    }
}
