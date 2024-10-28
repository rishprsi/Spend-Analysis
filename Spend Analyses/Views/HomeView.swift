//
//  HomeView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingMonthPopover = false // State for month popover
        @State private var showingYearPopover = false // State for year popover

        var body: some View {
            VStack {
                // Header with month and year buttons
                HStack {
                    Button(action: {
                        showingMonthPopover.toggle() // Show month popover
                    }) {
                        Text("\(monthString(from: viewModel.currentMonth))")
                            .font(.headline)
                    }
                    .popover(isPresented: $showingMonthPopover) {
                        List(viewModel.monthNames, id: \.self) { month in
                            Button(action: {
                                if let monthIndex = viewModel.monthNames.firstIndex(of: month) {
                                    viewModel.changeMonth(to: monthIndex + 1) // Update current month
                                }
                                showingMonthPopover = false // Dismiss the popover
                            }) {
                                Text(month)
                            }
                        }
                        .frame(width: 200)
                    }

                    Button(action: {
                        showingYearPopover.toggle() // Show year popover
                    }) {
                        Text("\(viewModel.year(from: viewModel.currentMonth))")
                            .font(.headline)
                    }
                    .popover(isPresented: $showingYearPopover) {
                        List(viewModel.availableYears, id: \.self) { year in
                            Button(action: {
                                viewModel.changeYear(to: year) // Update the selected year
                                showingYearPopover = false // Dismiss the popover
                            }) {
                                Text(String(year))
                            }
                        }
                        .frame(width: 100)
                    }

                    Button(action: {
                        viewModel.nextMonth() // Go to the next month
                    }) {
                        Image(systemName: "chevron.right") // Right arrow
                    }
                }
                .padding()

                // Calendar grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7) // 7 days in a week

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.daysInCurrentMonth, id: \.self) { day in
                        Text("\(day)")
                            .frame(width: 40, height: 40)
                            .background(viewModel.isSelected(day: day) ? Color.blue : Color.clear)
                            .foregroundColor(viewModel.isSelected(day: day) ? Color.white : Color.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                // Update selected date when a day is tapped
                                viewModel.selectedDate = Calendar.current.date(from: DateComponents(year: viewModel.year(from: viewModel.currentMonth), month: viewModel.month(from: viewModel.currentMonth), day: day)) ?? Date()
                            }
                    }
                }
                .padding()

                Spacer()
            }
        }

        // Helper function to get the month as a string
        private func monthString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: date)
        }
    }
