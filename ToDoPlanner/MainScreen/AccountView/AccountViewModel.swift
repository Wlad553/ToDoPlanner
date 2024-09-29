//
//  AccountViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/09/2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

@Observable
final class AccountViewModel {
    var userEmail = String()
    
    var isSignOutAlertPresented = false
}

// MARK: - Firebase SDK
extension AccountViewModel {
    func fetchUserData() {
        userEmail = Auth.auth().currentUser?.email ?? ""
    }
    
    func signOut() {
        if let providerData = Auth.auth().currentUser?.providerData {
            providerData.forEach { userInfo in
                switch userInfo.providerID {
                case "facebook.com":
                    LoginManager().logOut()
                    print("User did log out of Facebook")
                case "google.com":
                    GIDSignIn.sharedInstance.signOut()
                    print("User did log out of Google")
                case "password":
                    print("User did sign out")
                default:
                    print("User is signed in with \(userInfo.providerID)")
                    return
                }
            }
        }
        
        try? Auth.auth().signOut()
    }
}
