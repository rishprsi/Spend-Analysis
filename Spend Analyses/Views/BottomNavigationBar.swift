//
//  BottomNavigationBar.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//
import SwiftUI

struct BottomNavigationBar: View {
    @ObservedObject var viewModel: BottomNavViewModel

    var body: some View {
        HStack {
            ForEach(viewModel.items) { item in
                VStack {
                    Image(systemName: item.icon)
                    Text(item.title).font(.system(size: 10))
                }
                .onTapGesture {
                    viewModel.selectedTab = item
                }
                .foregroundColor(viewModel.selectedTab == item ? .blue : .gray)
                .padding()
            }
        }
        .background(Color.white)
        .shadow(radius: 2)
    }
}
