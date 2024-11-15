//
//  BudgetView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//


import SwiftUI

struct BudgetView: View {
    private let quantityFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 3
            return formatter
        }()
    @StateObject private var viewModel = BudgetViewModel()
    var body: some View {
        VStack{
            if (viewModel.newCategoryFlag){
                Form{
                    
                    Section(header: Text("New Expense")) {
                        TextField("Category Name", text: $viewModel.newCategory.title).frame(maxWidth: .infinity)
                        TextField("Budget", value: $viewModel.newCategory.budget, formatter: quantityFormatter).frame(maxWidth: .infinity)
                        HStack{
                            Spacer()
                            Button(action: {
                                // Button action here
                            }) {
                                Text("Save Category")
                                    .foregroundColor(.white) // Text color
                                    .padding(.vertical , 5)
                                    .padding(.horizontal , 10)
                                    .background(Color.blue) // Background color
                                    .cornerRadius(25) // Rounded corners
                            }
                        }.padding(.vertical , 2)
                        
                    }
                }.frame(maxHeight:210)
                
            }
            Text("Budget")
            Spacer()
        }
        .toolbar { // Toolbar to customize the navigation bar
            ToolbarItem(placement: .navigationBarTrailing) { // Placement of the button
                Button(action: {
                    
                        viewModel.toggleNewCategory()
                    
                }) {
                    Image(systemName:"plus") // Button label
                    
                }
            }
        }
    }
}
