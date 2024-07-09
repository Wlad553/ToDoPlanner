//
//  TaskDetalisViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/06/2024.
//

import SwiftUI

@Observable
final class TaskDetalisViewModel {
    let isEditingExistingToDoTask: Bool
    var draftToDoTask: ToDoTask
        
    // MARK: - Inits
    init(editedToDoTask: ToDoTask) {
        self.draftToDoTask = editedToDoTask
        self.isEditingExistingToDoTask = true
    }
    
    init() {
        self.draftToDoTask = ToDoTask()
        self.isEditingExistingToDoTask = false
    }
    
    // MARK: - Data manipulation funcs
    func applyChangesFor(editedToDoTask: Binding<ToDoTask>) {
        editedToDoTask.wrappedValue = draftToDoTask
    }
    
    func saveToDoTask(in toDoTasksList: Binding<[ToDoTask]>) {
        toDoTasksList.wrappedValue.append(draftToDoTask)
    }
    
    func delete(_ editedToDoTask: Binding<ToDoTask>, in toDoTasksList: Binding<[ToDoTask]>) {
        toDoTasksList.wrappedValue.removeAll { toDoTask in
            toDoTask == editedToDoTask.wrappedValue
        }
    }
    
    func revert(editedToDoTask: Binding<ToDoTask>) {
        draftToDoTask = editedToDoTask.wrappedValue
    }
}
