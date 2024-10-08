//
//  TaskCell.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/03/2024.
//

import SwiftUI

struct TaskCell: View {
    @Bindable var toDoTask: ToDoTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.midnightCharcoal)
            HStack(alignment: .top, spacing: 16) {
                CheckMarkButton(isCheckMarkFilled: $toDoTask.isCompleted)
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(toDoTask.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 17, weight: .semibold))
                    Text(toDoTask.dueDate.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(.gray)
                        .font(.system(size: 13))
                }
                .lineLimit(1)
                
                Spacer()
                
                Image(toDoTask.priority.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
            }
            .padding(16)
        }
    }
}

#Preview {
    TaskCell(toDoTask: ToDoTask(title: "Task name",
                                          desctiption: "It's task description",
                                          category: .home,
                                          dueDate: Date(),
                                          priority: .high,
                                          isCompleted: false))
}
