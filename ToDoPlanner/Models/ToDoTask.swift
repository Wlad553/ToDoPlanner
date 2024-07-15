//
//  DoTask.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 26/02/2024.
//

import Foundation
import SwiftData

@Model
final class ToDoTask: Identifiable {
    enum Priority: Int, Identifiable, CaseIterable, Comparable, Codable {
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
    
    enum Category: String, Hashable, CaseIterable, Identifiable, Codable {
        var id: String {
            rawValue
        }
        
        var name: String {
            rawValue.capitalized
        }
        
        case home, work, education, productivity, entertainment, other
    }
    
    let id = UUID()
    
    var title: String
    var desctiption: String
    var category: Category
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    
    // MARK: Inits
    init(title: String, desctiption: String, category: Category, dueDate: Date, priority: Priority, isCompleted: Bool) {
        self.title = title
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

// MARK: ToDoTask: Hashable
extension ToDoTask: Hashable {
    static func == (lhs: ToDoTask, rhs: ToDoTask) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
