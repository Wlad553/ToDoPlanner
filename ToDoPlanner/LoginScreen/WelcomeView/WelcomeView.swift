//
//  WelcomeView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 29/08/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State var viewModel = WelcomeViewModel()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.charcoal
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Image("appIconMedium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text("To Do Planner")
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 32)
                .padding(.top, 8)
                
                VStack {
                    Image("welcomeImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text("Take control of your tasks and achieve balance.")
                        .font(.system(.title2, design: .monospaced, weight: .heavy))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Button(action: {
                        viewModel.authAction = .signUp
                    }, label: {
                        RoundedButtonLabel(labelText: "Sign Up",
                                           foregroundColor: .white,
                                           backgroundColor: .lavenderBliss)
                    })
                    
                    Button(action: {
                        viewModel.authAction = .signIn
                    }, label: {
                        RoundedButtonLabel(labelText: "Sign In",
                                           foregroundColor: .white,
                                           backgroundColor: .gray)
                    })
                }
            } // -- VStack
            .padding(.horizontal, 8)
        } // -- ZStack
        .sheet(item: $viewModel.authAction, content: { authAction in
            LoginView(viewModel: LoginViewModel(authAction: authAction))
        })
    } // -- body
}

#Preview {
    WelcomeView()
}
