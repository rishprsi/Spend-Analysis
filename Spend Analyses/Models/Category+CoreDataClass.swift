//
//  Category+CoreDataClass.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 28/10/24.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    public var wrappedTitle: String {
        title ?? "Unknown Category"
    }
    
    public var expensesArray: [Expense] {
        let set = expenses as? Set<Expense> ?? []
        return set.sorted {
            $0.wrappedExpenseDateTime < $1.wrappedExpenseDateTime
        }
    }
}
