//
//  UnderlinedSecureField.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 29/09/2024.
//

import SwiftUI

struct UnderlinedSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 8) {
            SecureField(placeholder, text: $text)
            
            Rectangle()
                .foregroundStyle(.dimGray)
                .frame(height: 1)
                .blur(radius: 0)
        }
        .background(.charcoal)
    }
}

#Preview {
    @Previewable @State var text = String()
    
    return UnderlinedSecureField(placeholder: "Placeholder", text: $text)
}
