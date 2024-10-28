//
//  NavigationItem.swift
//  Spend Analyses
//
//  Created by Rishabh Pratap Singh on 26/10/24.
//
import SwiftUI

struct NavigationItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let view: AnyView // Using AnyView for flexibility
    
    static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
            return lhs.id == rhs.id
        }
}
