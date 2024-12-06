//
//  BudgetEditCategoryView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 01/12/24.
//
import SwiftUI
struct BudgetEditCategoryView: View {
    @State var category: Category
    var onSave: (Category) -> Void

    var body: some View {
        Form {
            TextField("Category Name", text: $category.title)
            TextField("Budget", value: $category.budget, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
            
            Button("Save") {
                onSave(category)
            }
        }
    }
}
