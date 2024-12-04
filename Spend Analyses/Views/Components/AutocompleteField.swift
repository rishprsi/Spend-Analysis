//
//  Autocomplete.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 29/10/24.
//

import SwiftUI

struct AutocompleteField: View {
    @State private var searchText: String = ""
    @State private var filteredCategories: [Category] = []
    @Binding var selectedCategory: Category?

    let categories: [Category]

    var body: some View {
       
            TextField("Expense Category", text: $searchText, onEditingChanged: { _ in
                updateFilteredFruits()
            }).frame(maxWidth: .infinity)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding()

            if !filteredCategories.isEmpty {
                List(filteredCategories) { category in
                    Text(category.wrappedTitle)
                        .onTapGesture {
                            searchText = category.wrappedTitle
                            selectedCategory = category
                            filteredCategories = []
                        }
                }
                .frame(maxHeight: 200) // Limit the height of the list
            }
    }

    private func updateFilteredFruits() {
        if searchText.isEmpty {
            filteredCategories = []
        } else {
            filteredCategories = categories.filter { $0.wrappedTitle.lowercased().contains(searchText.lowercased()) }
        }
    }
}
