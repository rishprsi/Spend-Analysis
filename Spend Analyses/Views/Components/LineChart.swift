import SwiftUI

struct LineChart: View {
    var dataPoints: [Double]
    var labels: [String] // Labels for each data point

    var body: some View {
        VStack {
            // Line chart with labels
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let maxValue = dataPoints.max() ?? 1
                let minValue = dataPoints.min() ?? 0
                
                Path { path in
                    for index in dataPoints.indices {
                        let xPosition = width * CGFloat(index) / CGFloat(dataPoints.count - 1)
                        let yPosition = height * CGFloat(1 - (dataPoints[index] - minValue) / (maxValue - minValue))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        } else {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
                
                // Circles and labels for each data point
                ForEach(dataPoints.indices, id: \.self) { index in
                    let xPosition = width * CGFloat(index) / CGFloat(dataPoints.count - 1)
                    let yPosition = height * CGFloat(1 - (dataPoints[index] - minValue) / (maxValue - minValue))
                    
                    VStack {
                        Text("\(Int(dataPoints[index]))") // Label for each point
                            .font(.caption)
                            .foregroundColor(.black)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                    }
                    .position(x: xPosition, y: yPosition)
                }
            }
            .frame(height: 200)
            
            // Indexes and legend
            HStack {
                ForEach(labels.indices, id: \.self) { index in
                    Text(labels[index])
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(
            dataPoints: [3, 5, 8, 6, 10, 7, 11, 13, 8],
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"]
        )
        .frame(width: 300, height: 250)
    }
}
