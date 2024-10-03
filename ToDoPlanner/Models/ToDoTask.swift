//
//  ToDoTask.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/02/2024.
//

import Foundation
import SwiftData
import Firebase

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
    
    var id = UUID()
    var title: String
    var desctiption: String
    var category: Category
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var lastUpdateTimestamp: TimeInterval = Date().timeIntervalSince1970
    
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
    
    init?(dict: [String: Any]) {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let categoryString = dict["category"] as? String,
              let category = Category(rawValue: categoryString),
              let dueDateTimestamp = dict["dueDate"] as? TimeInterval,
              let priorityRawValue = dict["priority"] as? Int,
              let priority = Priority(rawValue: priorityRawValue),
              let isCompleted = dict["isCompleted"] as? Bool,
              let lastUpdateTimestamp = dict["lastUpdateTimestamp"] as? TimeInterval
        else { return nil }
                
        self.id = id
        self.title = title
        self.desctiption = description
        self.category = category
        self.dueDate = Date(timeIntervalSince1970: dueDateTimestamp)
        self.priority = priority
        self.isCompleted = isCompleted
        self.lastUpdateTimestamp = lastUpdateTimestamp
    }
    
    // MARK: Utility funcs
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "title": title,
            "description": desctiption,
            "category": category.rawValue,
            "dueDate": dueDate.timeIntervalSince1970,
            "priority": priority.rawValue,
            "isCompleted": isCompleted,
            "lastUpdateTimestamp": lastUpdateTimestamp
        ]
    }
    
    func updateLastUpdateTimestamp() {
        self.lastUpdateTimestamp = Date().timeIntervalSince1970
    }
}

// MARK: ToDoTask: Hashable
extension ToDoTask: Hashable {
    static func == (lhs: ToDoTask, rhs: ToDoTask) -> Bool {
        lhs.id == rhs.id
        && lhs.lastUpdateTimestamp == rhs.lastUpdateTimestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
