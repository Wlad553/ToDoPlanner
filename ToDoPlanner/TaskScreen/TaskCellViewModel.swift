//
//  TaskCellViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/06/2024.
//

import SwiftUI

final class TaskCellViewModel: ObservableObject {
    @Binding var toDoTask: ToDoTask
    
    // MARK: - Init
    init(toDoTask: Binding<ToDoTask>) {
        self._toDoTask = toDoTask
    }
}
