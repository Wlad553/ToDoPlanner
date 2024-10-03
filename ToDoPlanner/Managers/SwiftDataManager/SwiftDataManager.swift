//
//  SwiftDataManager.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 13/07/2024.
//

import SwiftUI
import SwiftData
import OSLog

@MainActor
struct SwiftDataManager {
    var context: ModelContext {
        ToDoTaskModelContainer.shared.container.mainContext
    }
    
    // MARK: Saved Objects
    var toDoTasks: [ToDoTask]? {
        let fetchDescriptor = FetchDescriptor<ToDoTask>()
        var toDoTasks: [ToDoTask]?
        
        do {
            toDoTasks = try context.fetch(fetchDescriptor)
        } catch {
            Logger.swiftData.error("Error fetching toDoTasks: \(error.localizedDescription)")
        }
        
        return toDoTasks
    }
    
    // MARK: - Data manipulation funcs
    func applyChangesFor(toDoTask: ToDoTask, draftToDoTask: ToDoTask) {
        toDoTask.title = draftToDoTask.title
        toDoTask.desctiption = draftToDoTask.desctiption
        toDoTask.category = draftToDoTask.category
        toDoTask.dueDate = draftToDoTask.dueDate
        toDoTask.priority = draftToDoTask.priority
        toDoTask.isCompleted = draftToDoTask.isCompleted
        toDoTask.lastUpdateTimestamp = draftToDoTask.lastUpdateTimestamp
    }
    
    func save(toDoTask: ToDoTask) {
        context.insert(toDoTask)
    }
    
    func delete(toDoTask: ToDoTask) {
        context.delete(toDoTask)
    }
    
    func deleteAllToDoTasks() {
        toDoTasks?.forEach({ toDoTask in
            context.delete(toDoTask)
        })
    }
}
