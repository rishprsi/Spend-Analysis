//
//  PieChart.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/11/24.
//
import SwiftUI

struct PieSlice: Identifiable {
    var id = UUID()
    var value: Double
    var color: Color
    var label: String // Add a label for each slice
}

struct PieChart: View {
    var slices: [PieSlice]
    
    private var totalValue: Double {
        slices.map { $0.value }.reduce(0, +)
    }

    var body: some View {
        VStack {
            // Pie chart view
            GeometryReader { geometry in
                let radius = min(geometry.size.width, geometry.size.height) / 2
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                ZStack {
                    ForEach(slices.indices) { index in
                        let startAngle = angle(for: index)
                        let endAngle = angle(for: index + 1)
                        let midAngle = Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
                        let labelPosition = CGPoint(
                            x: center.x + radius * 0.7 * cos(CGFloat(midAngle.radians)),
                            y: center.y + radius * 0.7 * sin(CGFloat(midAngle.radians))
                        )
                        
                        // Draw each slice
                        Path { path in
                            path.move(to: center)
                            path.addArc(center: center,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
                        }
                        .fill(slices[index].color)
                        
                        // Add label in the middle of each slice
                        Text(String(format: "%.0f%%", slices[index].value / totalValue * 100))
                            .position(labelPosition)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 200)
            
            // Legend
            VStack(alignment: .leading) {
                ForEach(slices) { slice in
                    HStack {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 10, height: 10)
                        Text(slice.label)
                            .font(.caption)
                    }
                }
            }
            .padding(.top)
        }
    }

    private func angle(for index: Int) -> Angle {
        let cumulativeValue = slices.prefix(index).map { $0.value }.reduce(0, +)
        return .degrees(360 * cumulativeValue / totalValue - 90)
    }
}


