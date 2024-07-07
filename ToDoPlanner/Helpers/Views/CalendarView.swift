//
//  CalendarView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/07/2024.
//

import SwiftUI
import UIKit

struct CalendarView: UIViewRepresentable {
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate {
        var selectedDate: Binding<Date>
        
        init(selectedDate: Binding<Date>) {
            self.selectedDate = selectedDate
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let selectedDate = dateComponents?.date {
                self.selectedDate.wrappedValue = selectedDate
            }
        }
    }
    
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        let calendarSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 294)
            ])
        
        calendarView.calendar = Calendar.current
        calendarView.timeZone = .current
        calendarView.fontDesign = .rounded
        calendarView.selectionBehavior = calendarSelection
        
        calendarSelection.setSelected(dateComponents, animated: false)
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        let calendarSelection = uiView.selectionBehavior as? UICalendarSelectionSingleDate
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        calendarSelection?.setSelected(dateComponents, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate)
    }
}
