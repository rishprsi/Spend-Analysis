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
                        HStack{
                            Text("Title").foregroundColor(.secondary)
                            TextField("Category", text: $viewModel.newCategory.title).multilineTextAlignment(.trailing)
                        }
                        HStack{
                            Text("Budget").foregroundColor(.secondary)
                            TextField("0.00", value: $viewModel.newCategory.budget, formatter: quantityFormatter).multilineTextAlignment(.trailing)
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                viewModel.addCategory();
                                // Button action here
                            }) {
                                Text("Save Category")
                                    .foregroundColor(.white) // Text color
                                    .padding(.vertical , 5)
                                    .padding(.horizontal , 10)
                                    .background(Color.blue) // Background color
                                    .cornerRadius(25) // Rounded corners
                            }.buttonStyle(PlainButtonStyle())
                        }.padding(.vertical , 2)
                        
                    }
                }.frame(maxHeight:210)
                
            }
            Spacer()
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Budget")
                            .font(.headline)
                        
                        // Display the budget for the category
                        let totalBudget = viewModel.categories
                            .reduce(0) { $0 + $1.budget }
                        Text("Budget: \(totalBudget, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Calculate and display the total spent
                        let totalSpent = viewModel.currentExpenses
                            .reduce(0) { $0 + $1.amount } // Sum the amounts
                        Text("Spent: \(totalSpent, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                ForEach(viewModel.categories, id: \.id) { category in
                    
                    BudgetAccordionRow(
                        category: category,
                        totalSpent: viewModel.currentExpenses
                            .filter { $0.category?.id == category.id } // Match the category
                            .reduce(0) { $0 + $1.amount },

                        isExpanded: Binding(
                            get: { viewModel.expandedCategory == category.id },
                            set: { viewModel.expandedCategory = $0 ? category.id : nil }
                        ),
                                                onUpdate: { updatedCategory in
                            viewModel.updateCategory(updatedCategory)
                        },
                        
                        onDelete: {
                            viewModel.deleteCategory(category)
                        }
                    )
                }
            }
        }
        .toolbar { // Toolbar to customize the navigation bar
            ToolbarItem(placement: .navigationBarTrailing) { // Placement of the button
                Button(action: {
                        viewModel.toggleNewCategory()
                }) {
                    Image(systemName:"plus") // Button label
                }
            }
        }.onDisappear(){
            
            viewModel.cleanupInvalidEntries()
            print("Budget values are updated")
        }
        
    }
    }
