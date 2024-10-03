//
//  LoginView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/08/2024.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    @State private var upperButtonsStackOpacity: CGFloat = 1
    @State private var bottomLogInControlsPadding: CGFloat = 0
    
    private let upperButtonsStackFrameHeight: CGFloat = 148
    private let bridge = BridgeVCView()
    
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isTextFieldFocused: Bool
    
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
                            viewModel.performFacebookSignIn()
                        }, label: {
                            RoundedButtonLabel(logoImage: Image("facebookLogo"),
                                               labelText: "Sign in with Facebook",
                                               foregroundColor: .white,
                                               backgroundColor: .facebookButton)
                        })
                        
                        Button(action: {
                            viewModel.performGoogleSignIn(withPresenting: bridge.viewController)
                        }, label: {
                            RoundedButtonLabel(logoImage: Image("googleLogo"),
                                               labelText: "Sign in with Google",
                                               foregroundColor: .black,
                                               backgroundColor: .white)
                            .foregroundStyle(.charcoal)
                        })
                        
                        Divider()
                            .padding(.top, 16)
                    } // -- ZStack -> VStack -> VStack
                    .frame(height: upperButtonsStackFrameHeight)
                    .opacity(upperButtonsStackOpacity)
                    .onChange(of: isTextFieldFocused) { _, isTextFieldFocused in
                        if isTextFieldFocused {
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
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            
                            UnderlinedSecureField(placeholder: "Password",text: $viewModel.password)
                        } // -- ZStack -> VStack -> VStack -> VStack
                        
                        Button(action: {
                            
                            if viewModel.authAction == .signIn {
                                viewModel.performEmailSignIn()
                            } else if  viewModel.authAction == .signUp {
                                viewModel.performEmailSignUp()
                            }
                            
                        }, label: {
                            ZStack(alignment: .leading) {
                                RoundedButtonLabel(labelText: viewModel.authAction.string,
                                                   foregroundColor: .white,
                                                   backgroundColor: viewModel.isSignInUpInProgress ? .gray : .lavenderBliss)
                                
                                ProgressView()
                                    .padding(.leading, 8)
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .opacity(viewModel.isSignInUpInProgress ? 1 : 0)
                            }
                        })
                        .disabled(viewModel.isSignInUpInProgress)
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
        .addBridge(bridge)
        .onChange(of: viewModel.successfullyLoggedIn) { _, successfullyLoggedIn in
            if successfullyLoggedIn {
                appState.welcomeViewIsPresented.toggle()
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isSignInUpErrorAlertPresented) {
            Button("Close") {
                viewModel.isSignInUpErrorAlertPresented.toggle()
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(authAction: .signIn))
}
