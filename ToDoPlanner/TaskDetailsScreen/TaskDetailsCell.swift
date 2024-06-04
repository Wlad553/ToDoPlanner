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
                .padding(.vertical, -19)
            HStack(alignment: .center, spacing: 12) {
                leftView
                Text(text)
                    .font(.system(size: 16))
                
                Spacer()
                
                rightView
                    .padding(.trailing, 12)
            }
            .foregroundStyle(.white)
            .lineLimit(1)
        }
        .padding([.all], 19)
    }
}

#Preview {
    TaskDetailsCell(text: "Category") {
        Image(systemName: "list.bullet")
    } rightView: {
        EmptyView()
    }
}
