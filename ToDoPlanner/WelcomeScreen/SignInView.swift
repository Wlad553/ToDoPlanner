//
//  SignInView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/08/2024.
//

import SwiftUI

struct SignInView: View {
    @State private var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack {
            Color.charcoal
            
            VStack {
                UnderlinedTextField(placeholder: "Email", text: $viewModel.email)
                UnderlinedTextField(placeholder: "Password",text: $viewModel.password)
            }
            .background(.charcoal)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SignInView()
}
