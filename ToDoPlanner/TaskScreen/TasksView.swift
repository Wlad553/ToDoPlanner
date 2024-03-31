//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI

struct TasksView: View {
    var viewModel: TasksViewModel
    
    var body: some View {
        List(viewModel.tasks) { task in
            EmptyView()
        }
    }
}

#Preview {
    TasksView(viewModel: TasksViewModel())
}
