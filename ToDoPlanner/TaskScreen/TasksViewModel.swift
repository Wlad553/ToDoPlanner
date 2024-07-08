//
//  TasksViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/06/2024.
//

import SwiftUI

final class TasksViewModel: ObservableObject {
    @Binding var toDoTasksList: [ToDoTask]
    @Binding var selectedDateComponents: DateComponents
    
    // MARK: - Init
    init(toDoTasksList: Binding<[ToDoTask]>, selectedDateComponents: Binding<DateComponents>) {
        self._toDoTasksList = toDoTasksList
        self._selectedDateComponents = selectedDateComponents
    }
    
    // MARK: - Data manipulation funcs
    func delete(toDoTask toDoTaskToDelete: ToDoTask) {
        toDoTasksList.removeAll { toDoTask in
            toDoTaskToDelete.id == toDoTask.id
        }
    }
    
    func toggleIsCompleted(for toDoTask: ToDoTask) {
        guard let index = toDoTasksList.firstIndex(of: toDoTask) else { return }
        toDoTasksList[index].isCompleted.toggle()
    }
    
    // MARK: Array sorting funcs
    func toDoTasksSorted() -> [Dictionary<String, [ToDoTask]>.Element] {
        let filteredToDoTasksList = filteredToDoTasksList()
        let dateFormatter = NumericDateFormatter()
        var groupedTasksDictionary = Dictionary(grouping: filteredToDoTasksList, by: { dateFormatter.string(from: $0.dueDate) })
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
    
    private func filteredToDoTasksList() -> [ToDoTask] {
        guard selectedDateComponents != DateComponents() else { return toDoTasksList }
        return toDoTasksList.filter { toDoTask in
            let toDoTaskDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: toDoTask.dueDate)
            return toDoTaskDateComponents == selectedDateComponents
        }
    }
}
