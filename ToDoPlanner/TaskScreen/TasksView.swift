//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI

struct TasksView: View {
    @Bindable var viewModel: TasksViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.toDoTasksSorted(), id: \.key) { section, toDoTasks in
                Section {
                    ForEach(toDoTasks) { toDoTask in
                        if let taskIndex = viewModel.toDoTasks.firstIndex(of: toDoTask) {
                            TaskCell(doTask: $viewModel.toDoTasks[taskIndex])
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
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
    TasksView(viewModel: TasksViewModel())
}
