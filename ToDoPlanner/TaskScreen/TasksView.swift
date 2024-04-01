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
        ZStack {
            Color.blackBackground
                .ignoresSafeArea()
            
            List($viewModel.tasks) { task in
                TaskCell(doTask: task)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .listRowSpacing(4)
            .padding([.leading, .trailing], -8)
        }
    }
}

#Preview {
    TasksView(viewModel: TasksViewModel())
}
