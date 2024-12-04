//
//  BudgetAccordionRow.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 01/12/24.
//
import SwiftUI
struct BudgetAccordionRow: View {
    @State var category: Category
    @State var totalSpent: Float
    @Binding var isExpanded: Bool
    var onUpdate: (Category) -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            // Row Header
            HStack {
                VStack(alignment: .leading) {
                    Text(category.title)
                        .font(.headline)

                    // Display the budget
                    Text("Budget: \(category.budget, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Display the spent amount
                    Text("Spent: \(totalSpent, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                Spacer()

                // Expand/Collapse Button
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }.contentShape(Rectangle()) // Ensures only the header area is tappable for expanding/collapsing
                .onTapGesture {
                    isExpanded.toggle()
                }

            // Expanded View for Editing
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Category Name", text: $category.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Budget", value: $category.budget, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)

                    HStack {
                        Spacer()
                        Button("Save") {
                            onUpdate(category)
                            isExpanded = false
                        }.buttonStyle(PlainButtonStyle())
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)

                        Button("Delete") {
                            onDelete()
                        }.buttonStyle(PlainButtonStyle())
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
            }
        }
//        .padding()
        .background(Color(UIColor.systemBackground))
//        .cornerRadius(10)
//        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        .animation(.easeInOut, value: isExpanded)
    }
}
