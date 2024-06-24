//
//  TaskViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/03/2024.
//

import Foundation

@Observable
final class TasksViewModel {
    var toDoTasks: [ToDoTask] = [
        ToDoTask(name: "Task1", desctiption: "This is task1 description", category: .home, dueDate: Date() + 86401, priority: .high, isCompleted: false),
        ToDoTask(name: "Task2", desctiption: "This is task2 description", category: .home, dueDate: Date(), priority: .medium, isCompleted: false),
        ToDoTask(name: "Task3", desctiption: "This is task3 description", category: .home, dueDate: Date() - 60, priority: .low, isCompleted: false),
        ToDoTask(name: "Task4", desctiption: "This is task4 description", category: .work, dueDate: Date() - 86401, priority: .high, isCompleted: true),
        ToDoTask(name: "Task5", desctiption: "This is task5 description", category: .work, dueDate: Date() - (86401 * 31), priority: .low, isCompleted: true),
        ToDoTask(name: "Task6", desctiption: "This is task6 description", category: .work, dueDate: Date() + (86401 * 31), priority: .medium, isCompleted: true)
    ]
    
    func toDoTasksSorted() -> [Dictionary<String, [ToDoTask]>.Element] {
        let dateFormatter = NumericDateFormatter()
        var groupedTasksDictionary = Dictionary(grouping: toDoTasks, by: { dateFormatter.string(from: $0.dueDate) })
        groupedTasksDictionary.keys.forEach { key in
            groupedTasksDictionary[key]?.sort(by: { $0.dueDate < $1.dueDate })
        }
        
        let sortedTasksDictionary = groupedTasksDictionary.sorted { element1, element2 in
            guard let firstDate = dateFormatter.date(from: element1.key),
                  let secondDate = dateFormatter.date(from: element2.key)
            else { return false }
            return firstDate > secondDate
        }
        
        return sortedTasksDictionary
    }
    
    func sectionTitle(stringDate: String) -> String {
        let dateFormatter = NumericDateFormatter()
        let sectionTitle: String
        
        switch stringDate {
        case dateFormatter.string(from: Date()): sectionTitle = "Today, \(stringDate)"
        case dateFormatter.string(from: Date() - 86400): sectionTitle = "Yesterday, \(stringDate)"
        case dateFormatter.string(from: Date() + 86400): sectionTitle = "Tomorrow, \(stringDate)"
        default: sectionTitle = stringDate
        }
        
        return sectionTitle
    }
}
