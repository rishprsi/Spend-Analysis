//
//  MainView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = BottomNavViewModel()

    var body: some View {
        VStack {
            // Display the selected view
            viewModel.selectedTab.view
                .padding(.bottom, 50) // Adjust for the nav bar height

            Spacer()

            // Bottom navigation bar
            BottomNavigationBar(viewModel: viewModel)
        }
    }
}
