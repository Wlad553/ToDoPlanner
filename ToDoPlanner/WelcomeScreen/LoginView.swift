//
//  LoginView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/08/2024.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    private let upperButtonsStackFrameHeight: CGFloat = 208
    @State private var upperButtonsStackOpacity: CGFloat = 1
    @State private var bottomLogInControlsPadding: CGFloat = 0
    
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.charcoal
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                
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
                        
                        Divider()
                            .padding(.top, 24)
                    } // -- ZStack -> VStack -> VStack
                    .frame(height: upperButtonsStackFrameHeight)
                    .opacity(upperButtonsStackOpacity)
                    .onChange(of: isTextFieldFocused) { _, newValue in
                        if newValue {
                            withAnimation(.linear(duration: 0.4)) {
                                upperButtonsStackOpacity = 0
                            }
                        } else {
                            withAnimation(.linear(duration: 0.2)) {
                                upperButtonsStackOpacity = 1
                            }
                        }
                    }
                    
                    VStack {
                        VStack(spacing: 16) {
                            UnderlinedTextField(placeholder: "Email", text: $viewModel.email)
                            UnderlinedTextField(placeholder: "Password",text: $viewModel.password)
                        } // -- ZStack -> VStack -> VStack -> VStack
                        
                        Button(action: {
                            
                        }, label: {
                            RoundedButtonLabel(labelText: viewModel.authAction.string, backgroundStyle: .lavenderBliss)
                        })
                        .padding(.vertical, 16)
                        
                        Button(viewModel.authAction.opposite().string) {
                            viewModel.authAction = viewModel.authAction.opposite()
                        }
                        .foregroundStyle(.lavenderBliss)
                    } // -- ZStack -> VStack -> VStack
                    .background(Color.charcoal)
                    .focused($isTextFieldFocused)
                    .padding(.top, bottomLogInControlsPadding)
                    .onChange(of: isTextFieldFocused) { _, newValue in
                        withAnimation(.easeIn(duration: 0.2)) {
                            bottomLogInControlsPadding = newValue ? -upperButtonsStackFrameHeight : 0
                        }
                    }
                } // -- ZStack -> VStack
                .padding(.horizontal, 16)
            } // -- ZStack
            .navigationTitle(viewModel.authAction.string)
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
        } // -- NavigationStack
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(authAction: .signIn))
}