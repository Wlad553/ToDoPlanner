//
//  UnderlinedTextField.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/08/2024.
//

import SwiftUI

struct UnderlinedTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 8) {
            TextField(placeholder, text: $text)
            
            Rectangle()
                .foregroundStyle(.dimGray)
                .frame(height: 1)
                .blur(radius: 0)
        }
        .background(.charcoal)
    }
}

#Preview {
    @State var text = String()
    
    return UnderlinedTextField(placeholder: "Placeholder", text: $text)
}
