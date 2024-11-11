//
//  VisualizationView.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//

import SwiftUI

struct VisualizationView: View {
    var body: some View {
        VStack{
            Section(header:Text("Line Chart")){
                LineChart(dataPoints: [3, 5, 8, 6, 10, 7, 11, 13, 8],labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"])
                    .frame(width: 300, height: 200)
            }.padding()
                
            
            Spacer()
            Section(header: Text("Pie Chart")){
                PieChart(slices: [
                    PieSlice(value: 30, color: .red, label:"Food"),
                    PieSlice(value: 40, color: .green, label: "Transportation"),
                    PieSlice(value: 20, color: .blue, label: "Entertainment"),
                    PieSlice(value: 10, color: .yellow, label: "Utilities")
                ])
                .frame(width: 200, height: 200)
            }.padding()
            
            
        }
        
    }
}
