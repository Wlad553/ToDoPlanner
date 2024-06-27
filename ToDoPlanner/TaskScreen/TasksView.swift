//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI

struct TasksView: View {
    @Environment(MainViewModel.self) private var parentViewModel
    
    var body: some View {
        @Bindable var viewModel = parentViewModel
        List {
            ForEach(viewModel.toDoTasksSorted(), id: \.key) { section, toDoTasks in
                Section {
                    ForEach(toDoTasks) { toDoTask in
                        if let taskIndex = viewModel.toDoTasks.firstIndex(of: toDoTask) {
                            ZStack {
                                NavigationLink {
                                    TaskDetailsView(toDoTasks: $viewModel.toDoTasks,
                                                    toDoTask: $viewModel.toDoTasks[taskIndex])
                                } label: {
                                    EmptyView().opacity(0)
                                }
                                TaskCell(doTask: $viewModel.toDoTasks[taskIndex])
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                } header: {
                    Text(viewModel.sectionTitle(stringDate: section))
                        .textCase(.none)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: -4, leading: 0, bottom: 8, trailing: 0))
                }
            }
        }
        .listStyle(.grouped)
        .listRowSpacing(4)
        .listSectionSpacing(0)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(.charcoal)
        .padding([.leading, .trailing], -8)
    }
}

#Preview {
    TasksView()
        .environment(MainViewModel())
}
