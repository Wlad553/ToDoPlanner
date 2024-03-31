//
//  DoTask.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 26/02/2024.
//

import Foundation

struct DoTask: Hashable, Identifiable {
    enum Priority {
        case low, middle, high
    }
    
    var id = UUID()
    
    var name: String
    var desctiption: String
    var priority: Priority
    var isCompleted: Bool
}
