//
//  CalendarTasksViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 07/07/2024.
//

import SwiftUI

@Observable
final class CalendarTasksViewModel {
    var selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    var selectedCategory: ToDoTask.Category?
}
