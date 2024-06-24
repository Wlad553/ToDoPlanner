//
//  DoTask.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 26/02/2024.
//

import Foundation

struct ToDoTask: Hashable, Identifiable {
    
    enum Priority: String, Identifiable, CaseIterable, Comparable {
        static func < (lhs: ToDoTask.Priority, rhs: ToDoTask.Priority) -> Bool {
            func priority(_ priority: ToDoTask.Priority) -> Int {
                switch priority {
                case .high: return 2
                case .medium: return 1
                case .low: return 0
                }
            }
            
            return priority(lhs) < priority(rhs)
        }
        
        var id: String {
            rawValue
        }
        
        var imageName: String {
            rawValue
        }
        
        var name: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            }
        }
        
        case low = "lowPriority"
        case medium = "mediumPriority"
        case high = "highPriority"
    }
    
    enum Category: String, Hashable, CaseIterable, Identifiable, Comparable {
        static func < (lhs: ToDoTask.Category, rhs: ToDoTask.Category) -> Bool {
            lhs.name > rhs.name
        }
        
        var id: String {
            rawValue
        }
        
        var name: String {
            rawValue
        }
        
        case home = "Home"
        case work = "Work"
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
