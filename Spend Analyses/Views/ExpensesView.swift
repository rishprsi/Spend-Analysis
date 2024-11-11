//
//  ExpensesView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

struct ExpensesView: View {
    
    private let quantityFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 3
            return formatter
        }()
    
    @StateObject private var viewModel = ExpensesViewModel()
    var body: some View {
        VStack{
            if (viewModel.newExpenseFlag){
                Form{
                    
                    Section(header: Text("New Expense")) {
                        TextField("Expense Name", text: $viewModel.newExpense.title).frame(maxWidth: .infinity)
                        AutocompleteField(categories: viewModel.categories)
                        TextField("Amount", value: $viewModel.newExpense.amount, formatter: quantityFormatter).frame(maxWidth: .infinity)
                        TypeAutocompleteField()
                        HStack{
                            Spacer()
                            Button(action: {
                                // Button action here
                            }) {
                                Text("Save Expense")
                                    .foregroundColor(.white) // Text color
                                    .padding(.vertical , 5)
                                    .padding(.horizontal , 10)
                                    .background(Color.blue) // Background color
                                    .cornerRadius(25) // Rounded corners
                            }
                        }.padding(.vertical , 2)
                    }
                }.frame(maxHeight:300)
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
