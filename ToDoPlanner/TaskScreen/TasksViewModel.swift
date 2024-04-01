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
        ToDoTask(name: "Task1", desctiption: "This is task1 description", dueDate: Date() + 86401, priority: .high, isCompleted: false),
        ToDoTask(name: "Task2", desctiption: "This is task2 description", dueDate: Date(), priority: .middle, isCompleted: false),
        ToDoTask(name: "Task3", desctiption: "This is task3 description", dueDate: Date() - 60, priority: .low, isCompleted: false),
        ToDoTask(name: "Task4", desctiption: "This is task4 description", dueDate: Date() - 86401, priority: .high, isCompleted: true),
    ]
    
    var toDoTasksSorted: [Dictionary<String, [ToDoTask]>.Element] {
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
}
