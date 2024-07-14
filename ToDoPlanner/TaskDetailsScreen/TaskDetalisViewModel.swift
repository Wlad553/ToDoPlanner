//
//  TaskDetalisViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/06/2024.
//

import SwiftUI

@Observable
final class TaskDetalisViewModel {
    let swiftDataManager = SwiftDataManager()
    
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
                                 dueDate: editedToDoTask.dueDate,
                                 priority: editedToDoTask.priority,
                                 isCompleted: editedToDoTask.isCompleted)
    }
}
