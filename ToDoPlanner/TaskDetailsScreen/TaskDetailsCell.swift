//
//  TaskDetailsCell.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/05/2024.
//

import SwiftUI

struct TaskDetailsCell<LeftView: View, RightView: View>: View {
    let text: String
    @ViewBuilder let leftView: LeftView
    @ViewBuilder let rightView: RightView
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.midnightCharcoal)
                .padding(.horizontal, -20)
                .padding(.vertical, -9)
            HStack(alignment: .center, spacing: 12) {
                leftView
                Text(text)
                    .font(.system(size: 16))
                
                Spacer()
                
                rightView
                    .padding(.trailing, 4)
            }
            .foregroundStyle(.white)
            .lineLimit(1)
        }
        .padding(.horizontal, 19)
        .padding(.vertical, 9)
    }
}

#Preview {
    TaskDetailsCell(text: "Category") {
        Image(systemName: "list.bullet")
    } rightView: {
        EmptyView()
    }
}
