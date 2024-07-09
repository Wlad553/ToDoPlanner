//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI

struct TasksView: View {
    @State private var viewModel = TasksViewModel()
    
    @Binding var toDoTasksList: [ToDoTask]
    @Binding var selectedDateComponents: DateComponents
    
    var body: some View {
        ZStack {
            List {
                Section {
                    EmptyView()
                } header: {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            CategoryView(selectedCategory: $viewModel.selectedCategory, category: nil)
                            ForEach(ToDoTask.Category.allCases, id: \.self) { category in
                                CategoryView(selectedCategory: $viewModel.selectedCategory, category: category)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, -20)
                .padding(.top, -6)
                .padding(.bottom, -8)
                
                ForEach(viewModel.sorted(toDoTasksList: toDoTasksList, selectedDateComponents: selectedDateComponents), id: \.key) { section, toDoTasks in
                    Section {
                        ForEach(toDoTasks) { toDoTask in
                            if let taskIndex = toDoTasksList.firstIndex(of: toDoTask) {
                                ZStack {
                                    NavigationLink {
                                        TaskDetailsView(toDoTasksList: $toDoTasksList,
                                                        toDoTask: $toDoTasksList[taskIndex])
                                    } label: {
                                        EmptyView().opacity(0)
                                    }
                                    TaskCell(toDoTask: $toDoTasksList[taskIndex])
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.delete(toDoTask: toDoTask, in: $toDoTasksList)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .tint(.red)
                                    }
                                    Button {
                                        viewModel.toggleIsCompleted(for: toDoTask, in: $toDoTasksList)
                                    } label: {
                                        Label(toDoTask.isCompleted ? "Unmark\nas Done" : "Mark\nas Done",
                                              systemImage: toDoTask.isCompleted ? "xmark.circle" : "checkmark.circle")
                                        .tint(.purple)
                                    }
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        } // -- ForEach Row
                    } header: {
                        Text(viewModel.sectionTitle(stringDate: section))
                            .textCase(.none)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: -4, leading: 0, bottom: 8, trailing: 0))
                    } // -- Section
                } // -- ForEach Section
                .padding(.horizontal, -8)
            } // -- List
            .listStyle(.grouped)
            .listRowSpacing(4)
            .listSectionSpacing(0)
            .scrollContentBackground(.hidden)
            
            Text(viewModel.sorted(toDoTasksList: toDoTasksList, selectedDateComponents: selectedDateComponents).isEmpty ? "All done!" : String())
                .font(.system(size: 35,
                              weight: .bold,
                              design: .rounded))
                .foregroundStyle(.darkGrayish)
        } // -- ZStack
        .scrollIndicators(.hidden)
        .background(.charcoal)
    } // -- body
    
    init(toDoTasksList: Binding<[ToDoTask]>, selectedDateComponents: Binding<DateComponents> = .constant(DateComponents())) {
        self._toDoTasksList = toDoTasksList
        self._selectedDateComponents = selectedDateComponents
    }
}

#Preview {
    TasksView(toDoTasksList: .constant(MainViewModel().toDoTasks), selectedDateComponents: .constant(DateComponents()))
        .environment(MainViewModel())
}
