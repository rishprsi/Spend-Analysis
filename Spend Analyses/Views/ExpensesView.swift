import SwiftUI
import CoreData

struct ExpensesView: View {
    @StateObject private var viewModel = ExpensesViewModel()
    @State private var selectedType: String?
    @State private var selectedCategory: Category?
//    @State private var selectedDateTime: Date = Date()

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
                        HStack{
                            Text("Title").foregroundColor(.secondary)
                            TextField("Expense", text: $viewModel.newExpense.title).multilineTextAlignment(.trailing)
                        }
                        HStack{
                            Text("Amount").foregroundColor(.secondary)
                            TextField("0.00", value: $viewModel.newExpense.amount, formatter: quantityFormatter).multilineTextAlignment(.trailing)
                        }
                        HStack{
                            Text("Category").foregroundColor(.secondary)
                            Spacer()
                            Menu {
                                // Define dropdown options for budget interval
                                ForEach(viewModel.categories, id: \.id){ category in
                                    Button(action: {
                                        viewModel.newExpense.category = category
                                        selectedCategory = category
                                    }) {
                                        Text(category.title)
                                    }
                                }
                                
                                
                            } label: {
                                // Display the current selection
                                Text(selectedCategory?.title ?? "Select Category")
                                    .foregroundColor(selectedCategory  != nil ? .primary:.gray)
                            }.onAppear{
                                selectedCategory = viewModel.newExpense.category;
                            }
                        }
                        HStack{
                            Text("Date").foregroundColor(.secondary)
                            DatePicker(
                                            "",
                                            selection: $viewModel.newExpense.expenseDateTime,
                                            displayedComponents: .date
                                        )
                            .datePickerStyle(DefaultDatePickerStyle()) // Use a graphical style

//                            Text("Selected: \(viewModel.newExpense.wrappedExpenseDateTime, formatter: dateFormatter)")
                                    }.multilineTextAlignment(.trailing)
//                        HStack{
//                            Text("Type").foregroundColor(.secondary)
//                            Spacer()
//                            Menu {
//                                // Define dropdown options for budget interval
//                                ForEach(["One Time","Recurring"], id: \.self){ type in
//                                    Button(action: {
////                                        viewModel.newExpense.type = type as! String
////                                        viewModel.updateNewExpense()
//                                        selectedType = type
//                                        viewModel.newExpense.type = type
//                                    }) {
//                                        Text(type)
//                                    }.buttonStyle(PlainButtonStyle())
//                                }
//                                
//                                
//                            } label: {
//                                // Display the current selection
//                                Text(selectedType ?? "Select Type of Payment")
//                                    .foregroundColor(selectedType?.isEmpty == false ? .primary:.gray)
//                            }.onAppear{
//                                selectedType = viewModel.newExpense.type;
//                            }
//                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                // Button action here
                                viewModel.addExpense();
                            }) {
                                Text("Save Expense")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, 2).padding(.horizontal, 0)
                    }
                }
                .frame(maxHeight: 310)
            }


            List {
                ForEach(groupedExpenses, id: \.key) { date, expenses in
                    Section(header: Text(dateFormatter.string(from: date))) {
                        ForEach(expenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                        .font(.headline)
                                    Text("Amount: \(expense.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(expense.expenseDateTime ?? Date(), style: .time)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text(expense.category?.title ?? "Uncategorized").font(.subheadline).foregroundColor(.secondary)
                                }
                                
                            }
                            .onAppear {
                                if expenses.last == expense {
                                    viewModel.loadMoreExpenses()
                                }
                            }
                        }.onDelete(perform: viewModel.deleteExpense)
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
        }.onDisappear(){
            viewModel.cleanupInvalidEntries();
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
