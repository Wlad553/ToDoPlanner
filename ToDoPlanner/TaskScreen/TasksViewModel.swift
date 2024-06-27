//
//  TasksViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/06/2024.
//

import SwiftUI

final class TasksViewModel: ObservableObject {
    @Binding var toDoTasksList: [ToDoTask]
    
    // MARK: - Init
    init(toDoTasksList: Binding<[ToDoTask]>) {
        self._toDoTasksList = toDoTasksList
    }
    
    // MARK: - Data manipulation funcs
    func delete(toDoTask toDoTaskToDelete: ToDoTask) {
        toDoTasksList.removeAll { toDoTask in
            toDoTaskToDelete.id == toDoTask.id
        }
    }
    
    // MARK: Array sorting funcs
    func toDoTasksSorted() -> [Dictionary<String, [ToDoTask]>.Element] {
        let dateFormatter = NumericDateFormatter()
        var groupedTasksDictionary = Dictionary(grouping: toDoTasksList, by: { dateFormatter.string(from: $0.dueDate) })
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
