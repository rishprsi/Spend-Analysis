//
//  Expense+CoreDataProperties.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 28/10/24.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String
    @NSManaged public var amount: Float
    @NSManaged public var expenseDateTime: Date?
    @NSManaged public var type: String?
    @NSManaged public var category: Category?

}

//extension Optional where Wrapped == String {
//    var _bound: String? {
//        get {
//            return self
//        }
//        set {
//            self = newValue
//        }
//    }
//    public var bound: String {
//        get {
//            return _bound ?? ""
//        }
//        set {
//            _bound = newValue.isEmpty ? nil : newValue
//        }
//    }
//}

extension Expense : Identifiable {

}
