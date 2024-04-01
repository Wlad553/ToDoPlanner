//
//  DoTask.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 26/02/2024.
//

import Foundation

struct ToDoTask: Hashable, Identifiable {
    enum Priority: String {
        var imageName: String {
            rawValue
        }
        
        case low = "lowPriority"
        case middle = "mediumPriority"
        case high = "highPriority"
    }
    
    let id = UUID()
    
    var name: String
    var desctiption: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
}
