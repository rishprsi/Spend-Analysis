//
//  CategoryAccordion.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 05/11/24.
//

import SwiftUI

struct CategoryAccordionView: View {
    @State private var isExpanded: Bool = false
    @Binding var category: Category
    
    private let quantityFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 3
            return formatter
        }()

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            // Content inside the accordion
            VStack(alignment: .leading, spacing: 10) {
                Section(header: Text("Amount")  // Label
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))) {
                                            TextField("", value: $category.budget, formatter: quantityFormatter).frame(maxWidth: .infinity)
                    }
                    .textCase(nil)
            }
            .padding()
        } label: {
            // Custom header with leading and trailing text
            HStack {
                Text(category.title) // Leading text
                    .font(.headline)
                Spacer()
                Text(category.budget.description) // Trailing text
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

//struct AccordionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccordionView()
//    }
//}
