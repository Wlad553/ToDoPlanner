//
//  WelcomeView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 29/08/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var authAction: AuthAction?
    
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
                        authAction = .signUp
                    }, label: {
                        RoundedButtonLabel(labelText: "Sign Up",
                                           backgroundStyle: .lavenderBliss)
                    })
                    
                    Button(action: {
                        authAction = .signIn
                    }, label: {
                        RoundedButtonLabel(labelText: "Sign In",
                                           backgroundStyle: .gray)
                    })
                }
            } // -- VStack
            .padding(.horizontal, 8)
        } // -- ZStack
        .sheet(item: $authAction, content: { authAction in
            LoginView(authAction: authAction)
        })
    } // -- body
}

#Preview {
    WelcomeView()
}
