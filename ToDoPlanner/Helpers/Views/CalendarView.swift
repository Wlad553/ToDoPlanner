//
//  CalendarView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/07/2024.
//

import SwiftUI
import UIKit

struct CalendarView: UIViewRepresentable {
    class Coordinator: NSObject {
        var selectedDateComponents: Binding<DateComponents>
        var toDoTasksList: Binding<[ToDoTask]>
        var displayedAllowedDatesComponents: [DateComponents] = []
        var displayedSelectedDateComponents = DateComponents()
        
        init(selectedDateComponents: Binding<DateComponents>, toDoTasksList: Binding<[ToDoTask]>) {
            self.selectedDateComponents = selectedDateComponents
            self.toDoTasksList = toDoTasksList
        }
    }
    
    @Binding var toDoTasksList: [ToDoTask]
    @Binding var selectedDateComponents: DateComponents
    
    // MARK: - UIViewRepresentable funcs
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedDateComponents: $selectedDateComponents, toDoTasksList: $toDoTasksList)
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        let calendarSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 294)
            ])
        
        calendarView.calendar = Calendar.current
        calendarView.timeZone = .current
        calendarView.fontDesign = .rounded
        calendarView.selectionBehavior = calendarSelection
        
        calendarSelection.setSelected(selectedDateComponents, animated: false)
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        let calendarSelection = uiView.selectionBehavior as? UICalendarSelectionSingleDate
        let toDoTasksListDatesComponents = toDoTasksList
            .map({ $0.dueDate })
            .map({ Calendar.current.dateComponents([.year, .month, .day], from: $0) })
        
        if toDoTasksListDatesComponents != context.coordinator.displayedAllowedDatesComponents {
            let currentVisibleDateComponents = uiView.visibleDateComponents
            uiView.setVisibleDateComponents(DateComponents(day: 1), animated: false)
            uiView.setVisibleDateComponents(currentVisibleDateComponents, animated: false)
            context.coordinator.displayedAllowedDatesComponents = toDoTasksListDatesComponents
        } else if selectedDateComponents != context.coordinator.displayedSelectedDateComponents {
            calendarSelection?.setSelected(selectedDateComponents, animated: true)
        }
        
        context.coordinator.displayedSelectedDateComponents = selectedDateComponents
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarView.Coordinator: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        guard let dateComponents = dateComponents else { return true }
        let selectDateComponents = DateComponents(year: dateComponents.year,
                                                  month: dateComponents.month,
                                                  day: dateComponents.day)
        
        return displayedAllowedDatesComponents.contains(selectDateComponents)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let selectedDate = dateComponents?.date {
            withAnimation {
                self.selectedDateComponents.wrappedValue = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            }
        } else {
            selection.setSelected(displayedSelectedDateComponents, animated: false)
        }
    }
}
