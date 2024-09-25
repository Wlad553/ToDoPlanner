//
//  AccountView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 15/09/2024.
//

import SwiftUI

struct AccountView: View {
    @State var viewModel = AccountViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.charcoal
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(viewModel.userName)
                    .font(.system(size: 27, weight: .bold, design: .default))
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                
                Text(viewModel.userEmail)
                    .font(.system(size: 20, weight: .regular, design: .default))
                
                
                Spacer()
                
                Button {
                    
                } label: {
                    RoundedButtonLabel(labelText: "Log out",
                                       foregroundColor: .white,
                                       backgroundColor: .red)
                }
            }
            .padding()
        }
    }
}

#Preview {
    AccountView()
}
