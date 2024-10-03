//
//  TasksViewParentViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/06/2024.
//

import SwiftUI

@MainActor
@Observable
class TasksViewParentViewModel {
    let swiftDataManager = SwiftDataManager()
    let firebaseDatabaseManager = FirebaseDatabaseManager()
    
    var selectedDateComponents: DateComponents
    var searchText = String()
    var selectedCategory: ToDoTask.Category?
    
    let isSearchBarPresent: Bool
    var isTaskDetailsViewPresented = false {
        didSet {
            refreshToDoTasks()
        }
    }
    
    var toDoTasks: [ToDoTask] = []
    
    init(isSearchBarPresent: Bool = false,
         selectedDateComponents: DateComponents = DateComponents()) {
        
        self.isSearchBarPresent = isSearchBarPresent
        self.selectedDateComponents = selectedDateComponents
        
        refreshToDoTasks()
    }
    
    // MARK: - Data manipulation funcs
    func toggleIsCompleted(for toDoTask: ToDoTask) {
        toDoTask.isCompleted.toggle()
        updateLastUpdateTimestamp(for: toDoTask)
    }
    
    func updateLastUpdateTimestamp(for toDoTask: ToDoTask) {
        toDoTask.updateLastUpdateTimestamp()
        
        firebaseDatabaseManager.pushToDoTaskToFirebase(toDoTask: toDoTask)
    }
    
    func delete(toDoTask: ToDoTask) {
        withAnimation {
            toDoTasks.removeAll(where: { $0 == toDoTask })
        }
        
        firebaseDatabaseManager.deleteTaskFromFirebase(toDoTask: toDoTask)
        swiftDataManager.delete(toDoTask: toDoTask)
    }
    
    func refreshToDoTasks(animated: Bool = false) {
        if let fetchedToDoTasks = swiftDataManager.toDoTasks {
            
            if animated {
                withAnimation {
                    toDoTasks = fetchedToDoTasks
                }
            } else {
                toDoTasks = fetchedToDoTasks
            }
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
        
        if !searchText.isEmpty {
            toDoTasksFiltered = toDoTasksFiltered.filter { toDoTask in
                toDoTask.title.contains(searchText)
            }
        }
        
        if let selectedCategory = selectedCategory {
            toDoTasksFiltered = toDoTasksFiltered.filter { toDoTask in
                selectedCategory == toDoTask.category
            }
        }
        
        if selectedDateComponents != DateComponents() {
            toDoTasksFiltered = toDoTasksFiltered.filter { toDoTask in
                let toDoTaskDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: toDoTask.dueDate)
                return toDoTaskDateComponents == selectedDateComponents
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
