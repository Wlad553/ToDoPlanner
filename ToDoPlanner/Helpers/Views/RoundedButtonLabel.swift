//
//  RoundedButtonLabel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 05/09/2024.
//

import SwiftUI

struct RoundedButtonLabel: View {
    var logoImage: Image?
    let labelText: String
    let foregroundColor: Color
    let backgroundColor: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(labelText)
                .frame(maxWidth: .infinity, minHeight: 24)
                .foregroundStyle(foregroundColor)
                .font(.system(size: 15))
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(backgroundColor)
                }
            
            if let logoImage {
                logoImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    RoundedButtonLabel(logoImage: Image("facebookLogo"),
                       labelText: "Sign In with Facebook",
                       foregroundColor: .white,
                       backgroundColor: .facebookButton)
}
