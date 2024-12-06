import SwiftUI
import Charts

struct VisualizationView: View {
    @StateObject private var viewModel = VisualizationViewModel()

    var body: some View {
        VStack {
            // Line Chart: Total Expenses
            
            HStack{
                Text(viewModel.visualizationInterval).foregroundColor(.secondary)
                Spacer()
                Menu {
                    // Define dropdown options for budget interval
                    ForEach(["Line","Sector"], id: \.self){ type in
                        Button(action: {
                            viewModel.chartType = type
                        }) {
                            Text(type)
                        }
                    }
                } label: {
                    // Display the current selection
                    Text(viewModel.chartType)
                }
            }
            if viewModel.chartType == "Line"{
                Text("Total Expenses Over Time")
                    .font(.headline)
                    .padding(.top)

                Chart(viewModel.totalExpensesByInterval, id: \.0) { data in
                    AreaMark(
                            x: .value("Interval", data.0),
                            y: .value("Total Expenses", data.1)
                        )
                        .interpolationMethod(.catmullRom) // Smooth shading
                        .foregroundStyle(.blue.opacity(0.2))
                    LineMark(
                                        x: .value("Interval", data.0),
                                        y: .value("Total Expenses", data.1)
                                    )
                    .interpolationMethod(.catmullRom) // Smooth line
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
            }
            

            // Doughnut Chart: Category Expenses
            if  viewModel.chartType == "Sector"{
                Text("Expenses by Category")
                    .font(.headline)
                    .padding(.top)

                Chart(viewModel.categoryExpenses, id: \.0) { data in
                    SectorMark(
                        angle: .value("Amount", data.1),
                        innerRadius: .ratio(0.5), // Doughnut style
                        outerRadius: .ratio(0.9)
                    )
                    .foregroundStyle(by: .value("Category", data.0))
                    .annotation(position: .overlay, alignment: .center) {
                        Text("\(percentage(for: data.1, total: viewModel.expenses.reduce(0) { $0 + $1.amount }), specifier: "%.1f")%")
                            .font(.caption)
                        .foregroundColor(.primary)}
                }
                .frame(height: 200)
            }
            
        }
        .padding()
    }
        func percentage(for amount: Float, total: Float) -> Float {
            guard total > 0 else { return 0 }
            return (amount / total) * 100
        }
}
