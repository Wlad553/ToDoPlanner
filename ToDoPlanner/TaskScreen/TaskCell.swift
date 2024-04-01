//
//  TaskCell.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/03/2024.
//

import SwiftUI

struct TaskCell: View {
    @Binding var doTask: ToDoTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.grayRow)
            HStack(alignment: .top, spacing: 16) {
                CheckMarkImage(isCheckMarkFilled: $doTask.isCompleted)
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(doTask.name)
                        .foregroundStyle(.white)
                        .font(.system(size: 17, weight: .semibold))
                    Text(doTask.dueDate.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(.gray)
                        .font(.system(size: 13))
                }
                .lineLimit(1)
                
                Spacer()
                
                Image(doTask.priority.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
            }
            .padding([.all], 16)
        }
    }
}

#Preview {
    TaskCell(doTask: .constant(ToDoTask(name: "Task name",
                            desctiption: "It's task description",
                            dueDate: Date(),
                            priority: .high,
                            isCompleted: false)))
}
