//
//  HomeView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // Initialize the ViewModel
    //        @State private var showingMonthPopover = false // State for month popover
    let daysOfWeek = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    var body: some View {
        ScrollView{
            VStack {
                
                CalendarView(viewModel: viewModel)
                
                HStack(spacing: 16) {
                    // First Card: Selected Range or Start Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.selectedRangeTitle())
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            let spending = viewModel.spendingForSelectedRange()
                            let savings = viewModel.selectedRangeBudget() - spending
                            Text("SPENDING")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(spending, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.red)
                            
                            Text(savings < 0 ? "EXTRA SPENDING":"SAVINGS" )
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\( abs(savings),specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(savings < 0 ? .red: .green)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    // Second Card: Current Month
                    VStack(alignment: .leading, spacing: 8) {
                        let spending = viewModel.monthlyExpenses()
                        let savings = viewModel.monthlyRangeBudget() - spending
//                        let savings = viewModel.
                        Text(viewModel.monthName)
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SPENDING")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(spending,specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.red)
                            
                            Text(savings < 0 ?"EXTRA SPENDING":"SAVINGS")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\( abs(savings), specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(savings < 0 ? .red: .green)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding()
            }
            Spacer()
        }
    }
}
    
