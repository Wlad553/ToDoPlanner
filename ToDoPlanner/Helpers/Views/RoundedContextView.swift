//
//  TaskDetailsCellRightView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/06/2024.
//

import SwiftUI

struct RoundedContextView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 15))
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.charcoal)
            }
    }
}

#Preview {
    RoundedContextView(text: "24 May 2023")
}
