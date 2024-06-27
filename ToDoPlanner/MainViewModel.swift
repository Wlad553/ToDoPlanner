//
//  TaskViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/03/2024.
//

import Foundation

@Observable
final class MainViewModel {
    var toDoTasks: [ToDoTask] = [
        ToDoTask(name: "Task1", desctiption: "This is task1 description", category: .home, dueDate: Date() + 86401, priority: .high, isCompleted: false),
        ToDoTask(name: "Task2", desctiption: "This is task2 description", category: .home, dueDate: Date(), priority: .medium, isCompleted: false),
        ToDoTask(name: "Task3", desctiption: "This is task3 description", category: .home, dueDate: Date() - 60, priority: .low, isCompleted: false),
        ToDoTask(name: "Task32", desctiption: "This is task3 description", category: .home, dueDate: Date() + 60, priority: .low, isCompleted: false),
        ToDoTask(name: "Task4", desctiption: "This is task4 description", category: .work, dueDate: Date() - 86401, priority: .high, isCompleted: true),
        ToDoTask(name: "Task5", desctiption: "This is task5 description", category: .work, dueDate: Date() - (86401 * 31), priority: .low, isCompleted: true),
        ToDoTask(name: "Task6", desctiption: "This is task6 description", category: .work, dueDate: Date() + (86401 * 31), priority: .medium, isCompleted: true)
    ]
    
//    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.toDoTasks.forEach { task in
//                print("\(task.title) is completed " + "\(task.isCompleted)")
//            }
//        }
//    }
}
