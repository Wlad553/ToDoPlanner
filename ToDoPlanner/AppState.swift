//
//  AppState.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/09/2024.
//

import SwiftUI
import FirebaseAuth

@Observable
final class AppState {
    var welcomeViewIsPresented = false
    var appHasBeenLaunched = false
    
    func checkAuthenticationStatus() {
        if Auth.auth().currentUser == nil {
            self.welcomeViewIsPresented = true
        }
        
        self.appHasBeenLaunched = true
    }
}
