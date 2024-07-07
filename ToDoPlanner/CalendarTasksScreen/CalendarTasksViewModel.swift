//
//  CalendarTasksViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 07/07/2024.
//

import SwiftUI

final class CalendarTasksViewModel: ObservableObject {
    @Binding var toDoTasksList: [ToDoTask]
    
    // MARK: - Init
    init(toDoTasksList: Binding<[ToDoTask]>) {
        self._toDoTasksList = toDoTasksList
    }
}
