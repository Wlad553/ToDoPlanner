//
//  TaskCell.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/03/2024.
//

import SwiftUI

struct TaskCell: View {
    @ObservedObject private var viewModel: TaskCellViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.midnightCharcoal)
            HStack(alignment: .top, spacing: 16) {
                CheckMarkImage(isCheckMarkFilled: $viewModel.toDoTask.isCompleted)
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.toDoTask.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 17, weight: .semibold))
                    Text(viewModel.toDoTask.dueDate.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(.gray)
                        .font(.system(size: 13))
                }
                .lineLimit(1)
                
                Spacer()
                
                Image(viewModel.toDoTask.priority.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
            }
            .padding([.all], 16)
        }
    }
    
    init(toDoTask: Binding<ToDoTask>) {
        self.viewModel = TaskCellViewModel(toDoTask: toDoTask)
    }
}

#Preview {
    TaskCell(toDoTask: .constant(ToDoTask(name: "Task name",
                                          desctiption: "It's task description",
                                          category: .home,
                                          dueDate: Date(),
                                          priority: .high,
                                          isCompleted: false)))
}
