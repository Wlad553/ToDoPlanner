//
//  SwiftDataManager.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 13/07/2024.
//

import SwiftUI
import SwiftData

final class SwiftDataManager {
    var context: ModelContext?
    
    // MARK: - Data manipulation funcs
    func applyChangesFor(toDoTask: ToDoTask, draftToDoTask: ToDoTask) {
        toDoTask.title = draftToDoTask.title
        toDoTask.desctiption = draftToDoTask.desctiption
        toDoTask.category = draftToDoTask.category
        toDoTask.dueDate = draftToDoTask.dueDate
        toDoTask.priority = draftToDoTask.priority
        toDoTask.isCompleted = draftToDoTask.isCompleted
    }
    
    func save(toDoTask: ToDoTask) {
        context?.insert(toDoTask)
    }
    
    func delete(toDoTask: ToDoTask) {
        context?.delete(toDoTask)
    }
}
