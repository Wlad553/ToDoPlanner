//
//  AccountView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 15/09/2024.
//

import SwiftUI

struct AccountView: View {
    @State var viewModel = AccountViewModel()
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.charcoal
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Logged in as")
                    .font(.system(size: 27, weight: .bold, design: .default))
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                
                Text(viewModel.userEmail)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                
                Spacer()
                
                Button {
                    viewModel.isSignOutAlertPresented.toggle()
                } label: {
                    RoundedButtonLabel(labelText: "Log out",
                                       foregroundColor: .white,
                                       backgroundColor: .red)
                }
            }
            .padding()
        } // -- ZStack
        .onAppear {
            viewModel.fetchUserData()
        }
        .alert("Notice", isPresented: $viewModel.isSignOutAlertPresented) {
            Button("Sign Out", role: .destructive) {
                viewModel.signOut()
                appState.welcomeViewIsPresented.toggle()
            }
            
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Sign out from this device?")
        }
    }
}

#Preview {
    AccountView()
}
