//
//  PlaceholderTextEditor.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 20/05/2024.
//

import SwiftUI

struct PlaceholderTextEditor: View {
    var placeholder: String
    var placeholderColor: Color = .darkGrayish
    @Binding var text: String
    
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($isTextEditorFocused)
            if text.isEmpty && !isTextEditorFocused {
                Text(placeholder)
                    .foregroundStyle(placeholderColor)
            }
        }
    }
}

#Preview {
    PlaceholderTextEditor(placeholder: "Placeholder text...",
                          text: .constant(String()))
}
