//
//  TaskDetalisViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/06/2024.
//

import SwiftUI

final class TaskDetalisViewModel: ObservableObject {
    @Binding var toDoTasksList: [ToDoTask]
    @Binding var editedToDoTask: ToDoTask
    @Published var draftToDoTask: ToDoTask
    
    let isEditingExistingToDoTask: Bool
    
    // MARK: - Inits
    init(toDoTasksList: Binding<[ToDoTask]>, editedToDoTask: Binding<ToDoTask>) {
        self._toDoTasksList = toDoTasksList
        self._editedToDoTask = editedToDoTask
        self.draftToDoTask = editedToDoTask.wrappedValue
        self.isEditingExistingToDoTask = true
    }
    
    init(toDoTasksList: Binding<[ToDoTask]>) {
        self._toDoTasksList = toDoTasksList
        self._editedToDoTask = .constant(ToDoTask())
        self.draftToDoTask = ToDoTask()
        self.isEditingExistingToDoTask = false
    }
    
    // MARK: - Data manipulation funcs
    func saveToDoTask() {
        editedToDoTask = draftToDoTask
    }
    
    func addToDoTask() {
        toDoTasksList.append(draftToDoTask)
    }
    
    func deleteToDoTask() {
        toDoTasksList.removeAll { toDoTask in
            toDoTask == self.editedToDoTask
        }
    }
    
    func revertChanges() {
        draftToDoTask = editedToDoTask
    }
}
