//
//  DoTask.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 26/02/2024.
//

import Foundation

struct ToDoTask: Hashable, Identifiable {
    
    enum Priority: Int, Identifiable, CaseIterable, Comparable {
        static func < (lhs: ToDoTask.Priority, rhs: ToDoTask.Priority) -> Bool {
            lhs.rawValue < lhs.rawValue
        }
        
        var id: Int {
            rawValue
        }
        
        var imageName: String {
            switch self {
            case .low: return "lowPriority"
            case .medium: return "mediumPriority"
            case .high: return "highPriority"
            }
        }
        
        var name: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            }
        }
        
        case low, medium, high
    }
    
    enum Category: String, Hashable, CaseIterable, Identifiable {
        var id: String {
            rawValue
        }
        
        var name: String {
            rawValue.capitalized
        }
        
        case home, work, university, entertainment
    }
    
    let id = UUID()
    
    var title: String
    var desctiption: String
    var category: Category
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    
    init(name: String, desctiption: String, category: Category, dueDate: Date, priority: Priority, isCompleted: Bool) {
        self.title = name
        self.desctiption = desctiption
        self.category = category
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
    
    init() {
        self.title = String()
        self.desctiption = String()
        self.category = .home
        self.dueDate = .now
        self.priority = .low
        self.isCompleted = false
    }
}
