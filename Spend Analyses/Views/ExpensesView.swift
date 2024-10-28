//
//  ExpensesView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

struct ExpensesView: View {
    @StateObject private var viewModel = ExpensesViewModel()
    var body: some View {
        VStack{
            Text("Expenses")
            Spacer()
        }
        .toolbar { // Toolbar to customize the navigation bar
            ToolbarItem(placement: .navigationBarTrailing) { // Placement of the button
                Button(action: {
                    
                }) {
                    Image(systemName:"plus") // Button label
                    
                }
            }
        }
    }
}
