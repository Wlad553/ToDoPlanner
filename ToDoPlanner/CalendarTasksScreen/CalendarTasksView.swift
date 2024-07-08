//
//  CategoriesView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 28/06/2024.
//

import SwiftUI

struct CalendarTasksView: View {
    @ObservedObject private var viewModel: CalendarTasksViewModel
    @State private var selectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    var body: some View {
        VStack {
            CalendarView(selectedDateComponents: $selectedDateComponents, toDoTasksList: $viewModel.toDoTasksList)
                .padding(.top, -24)
                .padding(.bottom, 22)
                .padding(.horizontal, 4)
                .offset(y: -24)
                .scaleEffect(CGSize(width: 1.0, height: 0.9))
            
            Rectangle()
                .offset(y: -60)
                .foregroundStyle(.darkGrayish)
                .frame(height: 0.4)
                .blur(radius: 0)
            
            TasksView(toDoTasksList: $viewModel.toDoTasksList, selectedDateComponents: $selectedDateComponents)
                .padding(.top, -68)
        } // -- VStack
        .background(.charcoal)
    }
    
    init(toDoTasksList: Binding<[ToDoTask]>) {
        self.viewModel = CalendarTasksViewModel(toDoTasksList: toDoTasksList)
    }
}
