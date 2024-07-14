//
//  CategoryView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 08/07/2024.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory: ToDoTask.Category?
    @State var category: ToDoTask.Category?
    
    var body: some View {
        Text(category?.name ?? "All Tasks")
            .textCase(.none)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(selectedCategory == category ? .charcoal : .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                if selectedCategory == category {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.goldenSand)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.darkGrayish)
                }
            }
            .onTapGesture {
                withAnimation {
                    selectedCategory = category
                }
            }
    }
}
