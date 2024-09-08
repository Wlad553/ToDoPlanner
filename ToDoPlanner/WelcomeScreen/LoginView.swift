//
//  LoginView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/08/2024.
//

import SwiftUI

enum AuthAction: String, Identifiable {
    case signIn = "Sign In"
    case signUp = "Sign Up"
    
    var id: String {
        return rawValue
    }
    
    var string: String {
        rawValue
    }
    
    func opposite() -> AuthAction {
        if self == .signIn {
            return .signUp
        } else {
            return .signIn
        }
    }
}

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @State var authAction: AuthAction
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.charcoal
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    VStack {
                        Button(action: {
                            
                        }, label: {
                            RoundedButtonLabel(labelText: "Facebook", backgroundStyle: .lavenderBliss)
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            RoundedButtonLabel(labelText: "Google", backgroundStyle: .lavenderBliss)
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            RoundedButtonLabel(labelText: "Apple", backgroundStyle: .lavenderBliss)
                        })
                    }
                    .padding(.vertical)
                    
                    Divider()
                        .padding(.bottom)
                    
                    VStack(spacing: 16) {
                        UnderlinedTextField(placeholder: "Email", text: $viewModel.email)
                        UnderlinedTextField(placeholder: "Password",text: $viewModel.password)
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        RoundedButtonLabel(labelText: authAction.string, backgroundStyle: .lavenderBliss)
                    })
                    .padding(.vertical, 16)
                    
                    Button(authAction.opposite().string) {
                        authAction = authAction.opposite()
                    }
                    .foregroundStyle(.lavenderBliss)
                }
                .padding(.horizontal, 16)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(.white)
                    })
                }
            }
        }
    }
}

#Preview {
    LoginView(authAction: .signIn)
}
