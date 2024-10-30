//
//  ExpensesView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

struct ExpensesView: View {
    
    @StateObject private var viewModel = ExpensesViewModel()
    var body: some View {
        VStack{
            if (viewModel.newExpenseFlag){
                Form{
                    Section(header: Text("New Expense")) {
                        TextField("Title", text: $viewModel.newExpense.title).frame(maxWidth: .infinity)
                        AutocompleteField(categories: viewModel.categories)
                        TextField("Amount", value: $viewModel.newExpense.amount, format: .number).frame(maxWidth: .infinity)
                        TypeAutocompleteField()
                    }
                }
            }
            Text("List of expenses")
        }
        .toolbar { // Toolbar to customize the navigation bar
            ToolbarItem(placement: .navigationBarTrailing) { // Placement of the button
                Button(action: {
                    viewModel.toggleNewExpense()
                }) {
                    Image(systemName:"plus") // Button label
                    
                }
            }
        }
    }
}
