//
//  AuthAction.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 03/10/2024.
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
