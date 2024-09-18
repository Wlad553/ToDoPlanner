//
//  TasksViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/06/2024.
//

import SwiftUI

@MainActor
@Observable
final class TasksViewModel {
    let swiftDataManager = SwiftDataManager()
    
    var selectedDateComponents: Binding<DateComponents>
    var searchText: Binding<String>
    var selectedCategory: Binding<ToDoTask.Category?>
    
    let isSearchBarPresent: Bool
    
    var toDoTasks: [ToDoTask] = []
    
    init(isSearchBarPresent: Bool = false,
         selectedDateComponents: Binding<DateComponents> = .constant(DateComponents()),
         searchText: Binding<String> = .constant(String()),
         selectedCategory: Binding<ToDoTask.Category?>) {
        
        self.isSearchBarPresent = isSearchBarPresent
        self.selectedDateComponents = selectedDateComponents
        self.searchText = searchText
        self.selectedCategory = selectedCategory
        
        refreshToDoTasks()
    }
    
    // MARK: - Data manipulation funcs
    func toggleIsCompleted(for toDoTask: ToDoTask) {
        toDoTask.isCompleted.toggle()
    }
    
    func delete(toDoTask: ToDoTask) {
        withAnimation {
            toDoTasks.removeAll(where: { $0 == toDoTask })
        }
        
        swiftDataManager.delete(toDoTask: toDoTask)
    }
    
    func refreshToDoTasks() {
        if let fetchedToDoTasks = swiftDataManager.toDoTasks {
            toDoTasks = fetchedToDoTasks
        }
    }
    
    // MARK: Array sorting funcs
    func toDoTasksSorted() -> [Dictionary<String, [ToDoTask]>.Element] {
        let dateFormatter = NumericDateFormatter()
        let toDoTasksFiltered = toDoTasksFiltered()
        
        var groupedTasksDictionary = Dictionary(grouping: toDoTasksFiltered, by: { dateFormatter.string(from: $0.dueDate) })
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
    
    private func toDoTasksFiltered() -> [ToDoTask] {
        var toDoTasksFiltered = toDoTasks
        
        if !searchText.wrappedValue.isEmpty {
            toDoTasksFiltered = toDoTasksFiltered.filter { toDoTask in
                toDoTask.title.contains(searchText.wrappedValue)
            }
        }
        
        if let selectedCategory = selectedCategory.wrappedValue {
            toDoTasksFiltered = toDoTasksFiltered.filter { toDoTask in
                selectedCategory == toDoTask.category
            }
        }
        
        if selectedDateComponents.wrappedValue != DateComponents() {
            toDoTasksFiltered = toDoTasksFiltered.filter { toDoTask in
                let toDoTaskDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: toDoTask.dueDate)
                return toDoTaskDateComponents == selectedDateComponents.wrappedValue
            }
        }
        return toDoTasksFiltered
    }
    
    // MARK: Utility funcs
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
