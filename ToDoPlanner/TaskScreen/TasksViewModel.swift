//
//  TasksViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/06/2024.
//

import SwiftUI

@Observable
final class TasksViewModel {
    let swiftDataManager = SwiftDataManager()
    
    var searchText = String()
    var selectedCategory: ToDoTask.Category?
    
    // MARK: - Data manipulation funcs
    func toggleIsCompleted(for toDoTask: ToDoTask) {
        toDoTask.isCompleted.toggle()
    }
    
    // MARK: Array sorting funcs
    func sorted(toDoTasksList: [ToDoTask], selectedDateComponents: DateComponents) -> [Dictionary<String, [ToDoTask]>.Element] {
        let dateFormatter = NumericDateFormatter()
        let filteredToDoTasksList = filtered(toDoTasksList: toDoTasksList, selectedDateComponents: selectedDateComponents)
        
        var groupedTasksDictionary = Dictionary(grouping: filteredToDoTasksList, by: { dateFormatter.string(from: $0.dueDate) })
        groupedTasksDictionary.keys.forEach { key in
            groupedTasksDictionary[key]?.sort(by: { $0.dueDate < $1.dueDate })
        }
        
        let sortedTasksDictionary = groupedTasksDictionary.sorted { element1, element2 in
            guard let firstDate = dateFormatter.date(from: element1.key),
                  let secondDate = dateFormatter.date(from: element2.key)
            else { return false }
            return firstDate < secondDate
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
    
    private func filtered(toDoTasksList: [ToDoTask], selectedDateComponents: DateComponents) -> [ToDoTask] {
        var filteredToDoTasksList = toDoTasksList
        
        if !searchText.isEmpty {
            filteredToDoTasksList = filteredToDoTasksList.filter { toDoTask in
                toDoTask.title.contains(searchText)
            }
        }
        
        if let selectedCategory = selectedCategory {
            filteredToDoTasksList = filteredToDoTasksList.filter { toDoTask in
                selectedCategory == toDoTask.category
            }
        }
        
        if selectedDateComponents != DateComponents() {
            filteredToDoTasksList = filteredToDoTasksList.filter { toDoTask in
                let toDoTaskDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: toDoTask.dueDate)
                return toDoTaskDateComponents == selectedDateComponents
            }
        }
        return filteredToDoTasksList
    }
}
