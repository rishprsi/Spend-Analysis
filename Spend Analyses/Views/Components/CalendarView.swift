import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: HomeViewModel

    let daysOfWeek = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    var body: some View {
        VStack {
            // Month Navigation
            HStack {
                Button(action: {
                    viewModel.previousMonth()
                }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(viewModel.monthName)
                    .font(.headline)

                Spacer()

                Button(action: {
                    viewModel.nextMonth()
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            // Days of the Week Header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .foregroundColor(day == "Sa" || day == "Su" ? .blue : .primary)
                }
            }

            // Calendar Grid
            GeometryReader { geometry in
                let gridWidth = geometry.size.width / 7 // Divide the total width into 7 columns
                
                    VStack(spacing: 5) {
                        let daysInMonth = viewModel.daysInCurrentMonth
                        let firstWeekday = viewModel.currentMonth.adjustedWeekdayForMonday(
                            weekday: viewModel.currentMonth.startOfMonthWeekday()
                        )
                        let totalDays = firstWeekday + daysInMonth.count
                        let rows = (totalDays / 7) + (totalDays % 7 == 0 ? 0 : 1)

                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: 8) {
                                ForEach(0..<7, id: \.self) { column in
                                    let dayIndex = row * 7 + column
                                    if dayIndex >= firstWeekday && dayIndex < totalDays {
                                        let day = dayIndex - firstWeekday + 1
                                        Button(action: {
                                            let normalizedMonth = viewModel.currentMonth.startOfMonth()
                                            let selectedDate = Calendar.current.date(bySetting: .day, value: day, of: normalizedMonth) ?? Date()
//                                            print("Selected Date is \(selectedDate) \(viewModel.currentMonth) \(day) \(normalizedMonth)")
                                            viewModel.selectDate(selectedDate)
                                        }) {
                                            Text("\(day)")
                                                .frame(width: gridWidth - 5, height: gridWidth - 5) // Ensure square cells
                                                .background(viewModel.isSelected(day: day) ? Color.black : Color.clear)
                                                .foregroundColor(viewModel.isSelected(day: day) ? .white : (column == 5 || column == 6 ? .blue : .primary))
                                                .clipShape(Circle())
                                        }
                                    } else {
                                        Spacer()
                                            .frame(width: gridWidth - 5, height: gridWidth - 5)
                                    }
                                }
                            }
                        }
                    
                }
            }
            .frame(height: 240) // Fixed height for calendar grid to prevent overlap
            .padding(.horizontal)
        }
        .padding()
    }
}

extension Date {
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components) ?? self
    }

    func startOfMonthWeekday() -> Int {
        let startOfMonth = self.startOfMonth()
        return Calendar.current.component(.weekday, from: startOfMonth)
    }

    func adjustedWeekdayForMonday(weekday: Int) -> Int {
        print("Getting the following weekday for Sunday: \(weekday)")
        return weekday == 1 ? 6 : weekday - 2 // Convert Sunday (1) to 7
    }
}
