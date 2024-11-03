//
//  Expense+CoreDataClass.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 28/10/24.
//
//

import Foundation
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    public var wrappedTitle: String {
        title ?? "Unknown Expense"
    }
    
    public var wrappedExpenseDateTime: Date {
        expenseDateTime ?? Date()
    }
}
