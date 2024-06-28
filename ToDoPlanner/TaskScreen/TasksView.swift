//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject private var viewModel: TasksViewModel
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.toDoTasksSorted(), id: \.key) { section, toDoTasks in
                    Section {
                        ForEach(toDoTasks) { toDoTask in
                            if let taskIndex = viewModel.toDoTasksList.firstIndex(of: toDoTask) {
                                ZStack {
                                    NavigationLink {
                                        TaskDetailsView(toDoTasksList: $viewModel.toDoTasksList,
                                                        toDoTask: $viewModel.toDoTasksList[taskIndex])
                                    } label: {
                                        EmptyView().opacity(0)
                                    }
                                    TaskCell(toDoTask: $viewModel.toDoTasksList[taskIndex])
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.delete(toDoTask: toDoTask)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .tint(.red)
                                    }
                                    Button {
                                        viewModel.toggleIsCompleted(for: toDoTask)
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
            } // -- List
            .listStyle(.grouped)
            .listRowSpacing(4)
            .listSectionSpacing(0)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .background(.charcoal)
            .padding([.leading, .trailing], -8)
            
            Text(viewModel.toDoTasksSorted().isEmpty ? "All done!" : String())
                .font(.system(size: 35,
                              weight: .bold,
                              design: .rounded))
                .foregroundStyle(.darkGrayish)
        } // -- ZStack
    }
    
    init(toDoTasksList: Binding<[ToDoTask]>) {
        self.viewModel = TasksViewModel(toDoTasksList: toDoTasksList)
    }
}

#Preview {
    TasksView(toDoTasksList: .constant(MainViewModel().toDoTasks))
        .environment(MainViewModel())
}
