//
//  TaskViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/03/2024.
//

import Foundation

@Observable
final class TasksViewModel {
    var tasks: [DoTask] = [
        DoTask(name: "Task1", desctiption: "This is task1 description", dueDate: Date(), priority: .high, isCompleted: false),
        DoTask(name: "Task2", desctiption: "This is task2 description", dueDate: Date(), priority: .middle, isCompleted: false),
        DoTask(name: "Task3", desctiption: "This is task3 description", dueDate: Date(), priority: .low, isCompleted: false),
        DoTask(name: "Task4", desctiption: "This is task4 description", dueDate: Date(), priority: .high, isCompleted: true),
    ]
}
