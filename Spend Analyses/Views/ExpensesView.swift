import SwiftUI
import CoreData

struct ExpensesView: View {
    @StateObject private var viewModel = ExpensesViewModel()

    private let quantityFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        return formatter
    }()

    var body: some View {
        VStack {
            if viewModel.newExpenseFlag {
                Form {
                    Section(header: Text("New Expense")) {
                        TextField("Expense Name", text: $viewModel.newExpense.title).frame(maxWidth: .infinity)
                        AutocompleteField(categories: viewModel.categories)
                        TextField("Amount", value: $viewModel.newExpense.amount, formatter: quantityFormatter).frame(maxWidth: .infinity)
                        TypeAutocompleteField()
                        HStack {
                            Spacer()
                            Button(action: {
                                // Button action here
                            }) {
                                Text("Save Expense")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .frame(maxHeight: 300)
            }

            Text("List of expenses")
                .font(.headline)

            List {
                ForEach(groupedExpenses, id: \.key) { date, expenses in
                    Section(header: Text(dateFormatter.string(from: date))) {
                        ForEach(expenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                        .font(.headline)
                                    Text("Amount: \(quantityFormatter.string(from: NSNumber(value: expense.amount)) ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(expense.expenseDateTime ?? Date(), style: .time)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .onAppear {
                                if expenses.last == expense {
                                    viewModel.loadMoreExpenses()
                                }
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleNewExpense()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    // Group expenses by day
    private var groupedExpenses: [(key: Date, value: [Expense])] {
        Dictionary(grouping: viewModel.expenses, by: { Calendar.current.startOfDay(for: $0.expenseDateTime ?? Date()) })
            .sorted { $0.key > $1.key }
    }

    // Date formatter for section headers
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
