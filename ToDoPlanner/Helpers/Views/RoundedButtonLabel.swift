//
//  RoundedButtonLabel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 05/09/2024.
//

import SwiftUI

struct RoundedButtonLabel<BackgroundStyle: ShapeStyle>: View {
    let labelText: String
    let backgroundStyle: BackgroundStyle
    
    var body: some View {
        Text(labelText)
            .frame(maxWidth: .infinity, minHeight: 24)
            .foregroundStyle(.white)
            .font(.system(size: 15))
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(backgroundStyle)
            }
    }
}

#Preview {
    RoundedButtonLabel(labelText: "Sign In", backgroundStyle: .gray)
}
