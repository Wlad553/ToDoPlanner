//
//  CheckMarkButton.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 31/03/2024.
//

import SwiftUI

struct CheckMarkButton: View {
    @Binding var isCheckMarkFilled: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(isCheckMarkFilled ? .lavenderBliss : .gray, lineWidth: 2)
                    .fill(isCheckMarkFilled ? .lavenderBliss : .clear)
                    .frame(width: geometry.size.width,
                           height: geometry.size.width)
                
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundStyle(isCheckMarkFilled ? .white : .clear)
                    .frame(width: geometry.size.width * 0.73,
                           height: geometry.size.width * 0.73)
            }
            .contentShape(Circle())
            .onTapGesture {
                withAnimation(Animation.checkMarkToggle()) {
                    isCheckMarkFilled.toggle()
                }
            }
        }
    }
}

#Preview {
    struct CheckMarkButtonContainer: View {
        @State private var isCheckMarkFilled = false
        
        var body: some View {
            CheckMarkButton(isCheckMarkFilled: $isCheckMarkFilled)
        }
    }
    
    return CheckMarkButtonContainer()
}
