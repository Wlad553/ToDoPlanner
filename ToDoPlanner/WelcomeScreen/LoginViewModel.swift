//
//  LoginViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/08/2024.
//

import Foundation

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

@Observable
final class LoginViewModel {
    var authAction: AuthAction
    
    var email = String()
    var password = String()
    
    init(authAction: AuthAction) {
        self.authAction = authAction
    }
}
