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
                .padding(-20)
            HStack(alignment: .center, spacing: 12) {
                leftView
                Text(text)
                    .font(.system(size: 15))
                Spacer()
                
                rightView
            }
            .foregroundStyle(.white)
            .lineLimit(1)
        }
        .padding([.all], 20)
    }
}

#Preview {
    TaskDetailsCell(text: "Category") {
        Image(systemName: "list.bullet")
    } rightView: {
        EmptyView()
    }
}
