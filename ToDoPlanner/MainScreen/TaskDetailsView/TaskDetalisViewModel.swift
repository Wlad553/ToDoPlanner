//
//  TaskDetalisViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/06/2024.
//

import SwiftUI

@MainActor
@Observable
final class TaskDetalisViewModel {
    let swiftDataManager = SwiftDataManager()
    let firebaseDatabaseManager = FirebaseDatabaseManager()
    
    var draftToDoTask: ToDoTask
    var editedToDoTask: ToDoTask
    
    let isEditingExistingToDoTask: Bool
        
    // MARK: - Inits
    init(editedToDoTask: ToDoTask? = nil) {
        if let editedToDoTask = editedToDoTask {
            self.draftToDoTask = ToDoTask(title: editedToDoTask.title,
                                          desctiption: editedToDoTask.desctiption,
                                          category: editedToDoTask.category,
                                          dueDate: editedToDoTask.dueDate,
                                          priority: editedToDoTask.priority,
                                          isCompleted: editedToDoTask.isCompleted)
            self.editedToDoTask = editedToDoTask
            self.isEditingExistingToDoTask = true
            
        } else {
            self.draftToDoTask = ToDoTask()
            self.editedToDoTask = ToDoTask()
            self.isEditingExistingToDoTask = false
        }
    }
    
    // MARK: - Data manipulation funcs
    func revertDraftToDoTask() {
        draftToDoTask = ToDoTask(title: editedToDoTask.title,
                                 desctiption: editedToDoTask.desctiption,
                                 category: editedToDoTask.category,
                                 dueDate: isEditingExistingToDoTask ? editedToDoTask.dueDate : Date(),
                                 priority: editedToDoTask.priority,
                                 isCompleted: editedToDoTask.isCompleted)
    }
    
    func saveToDoTask() {
        draftToDoTask.updateLastUpdateTimestamp()
        draftToDoTask.id = editedToDoTask.id
        
        firebaseDatabaseManager.pushToDoTaskToFirebase(toDoTask: draftToDoTask)
         
        if isEditingExistingToDoTask {
            swiftDataManager.applyChangesFor(toDoTask: editedToDoTask, draftToDoTask: draftToDoTask)
        } else {
            swiftDataManager.save(toDoTask: draftToDoTask)
        }
    }
    
    func deleteEditedToDoTask() {
        firebaseDatabaseManager.deleteTaskFromFirebase(toDoTask: editedToDoTask)
        swiftDataManager.delete(toDoTask: editedToDoTask)
    }
}
