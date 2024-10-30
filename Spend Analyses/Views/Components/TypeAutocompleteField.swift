//
//  TypeAutocompleteField.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 29/10/24.
//

import SwiftUI

struct TypeAutocompleteField: View {
    @State private var searchText: String = ""
    @State private var filteredTypes: [String] = []

    let types: [String] = ["One Time", "Recurring"]

    var body: some View {
       
            TextField("Expense Type", text: $searchText, onEditingChanged: { _ in
                updateFilteredTypes()
            }).frame(maxWidth: .infinity)

            if !filteredTypes.isEmpty {
                List(filteredTypes, id:\.self) { type in
                    Text(type)
                        .onTapGesture {
                            searchText = type
                            filteredTypes = []
                        }
                }
                .frame(maxHeight: 200) // Limit the height of the list
            }
    }

    private func updateFilteredTypes() {
        if searchText.isEmpty {
            filteredTypes = []
        } else {
            filteredTypes = types.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
}
