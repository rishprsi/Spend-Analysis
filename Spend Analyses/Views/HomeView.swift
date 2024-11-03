//
//  HomeView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // Initialize the ViewModel
        @State private var showingMonthPopover = false // State for month popover

        var body: some View {
            VStack {
                // Header with month name and navigation buttons
                HStack {
                    Button(action: {
                        viewModel.previousMonth() // Go to previous month
                    }) {
                        Image(systemName: "chevron.left") // Left arrow
                    }

                    Text(viewModel.monthName)
                        .font(.headline)
                        .padding()

                    Button(action: {
                        viewModel.nextMonth() // Go to next month
                    }) {
                        Image(systemName: "chevron.right") // Right arrow
                    }
                }
                
                // Calendar grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7) // 7 days in a week

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.daysInCurrentMonth, id: \.self) { day in
                        let date = Calendar.current.date(from: DateComponents(year: viewModel.year(from: viewModel.currentMonth), month: viewModel.month(from: viewModel.currentMonth), day: day))!
                        Text("\(day)")
                            .frame(width: 40, height: 40)
                            .background(viewModel.isSelected(day: day) ? Color.blue : Color.clear) // Highlight selected dates
                            .foregroundColor(viewModel.isSelected(day: day) ? Color.white : Color.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                viewModel.selectDate(date) // Select the date
                            }
                    }
                }
                .padding()

                Spacer()
            }
        }
    }
