//
//  LoginViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 27/08/2024.
//

import SwiftUI
import FBSDKLoginKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import OSLog

@Observable
final class LoginViewModel {
    let firebaseDatabaseManager = FirebaseDatabaseManager()
    
    var authAction: AuthAction
    
    var email = String()
    var password = String()
    
    var errorMessage = String()
    
    var isSignInUpInProgress = false
    var isSignInUpErrorAlertPresented = false
    var successfullyLoggedIn = false
    
    // MARK: Init
    init(authAction: AuthAction) {
        self.authAction = authAction
    }
    
    // MARK: Utility funcs
    private func setErrorMessage(for error: Error) {
        let error = error as NSError
        
        errorMessage = switch error.code {
                       case 17004, 17009: "Invalid email or password. Please, try again."
                       case 17007: "This email is already in use. Please, try again."
                       case 17008, 17034: "Invalid email format. Please, try again."
                       case 17020: "Network error. Please, check your internet connection or try again later."
                       case 17026: "Password must be at least 6 characters. Please, try again."
                       default: "Something went wrong. Please, try again."
        }
                
        self.isSignInUpErrorAlertPresented = true
    }
}

// MARK: - Facebook Sign In Flow
extension LoginViewModel {
    func performFacebookSignIn() {
        let loginManager = LoginManager()
        let nonce = LoginManager.randomNonceString()
        
        guard let configuration = LoginConfiguration(permissions: ["public_profile", "email"],
                                                     tracking: .limited,
                                                     nonce: LoginManager.sha256(nonce))
        else { return }
        
        loginManager.logIn(configuration: configuration) { result in
            switch result {
            case .success:
                Logger.auth.info("Logged In with FB")
                
                self.signIntoFirebaseWithFacebook(nonce: nonce)
                
            case .failed(let error):
                Logger.auth.error("FB Login Error: \(error.localizedDescription)")
                self.setErrorMessage(for: error)
                
            case .cancelled:
                break
            }
        }
    }
    
    private func signIntoFirebaseWithFacebook(nonce: String) {
        guard let accessTokenString = AuthenticationToken.current?.tokenString else { return }
        let credentials = OAuthProvider.credential(providerID: .facebook, idToken: accessTokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: credentials) { user, error in
            if let error {
                Logger.auth.error("Firebase FB user authorisation error: \(error.localizedDescription)")
                self.setErrorMessage(for: error)
                
                return
            }
            
            Logger.auth.info("Firebase FB user log in succeeded: \(String(describing: user))")
            self.fetchFacebookFields()
        }
    }
    
    private func fetchFacebookFields() {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"]).start { _, result, error in
            if let error {
                Logger.auth.error("Firebase FB user data fetch error: \(error.localizedDescription)")
                return
            }
            
            if let userData = result {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
                let fbUserProfile = try? JSONDecoder().decode(FBUserProfile.self, from: jsonData)
                
                self.pushUserToDatabase(name: fbUserProfile?.name, email: fbUserProfile?.email)
            }
        }
    }
}

// MARK: - Google Sign In Flow
extension LoginViewModel {
    func performGoogleSignIn(withPresenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] result, error in
            if let error {
                Logger.auth.error("Failed to log in with Google: \(error.localizedDescription)")
                self.setErrorMessage(for: error)
                
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { user, error in
                if let error {
                    Logger.auth.error("Failed to log into Firebase with Google: \(error.localizedDescription)")
                    self.setErrorMessage(for: error)

                    return
                }
                
                Logger.auth.info("Successfully logged into Firebase with Google")
                self.pushUserToDatabase(name: result?.user.profile?.name, email: result?.user.profile?.email)
            }
        }
    }
}

// MARK: - Email Sign In/Up Flow
extension LoginViewModel {
    func performEmailSignUp() {
        isSignInUpInProgress = true
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error {
                self.setErrorMessage(for: error)
                self.isSignInUpInProgress = false
                
                return
            }
            
            Logger.auth.info("Successfully logged into Firebase with User Email")
            self.pushUserToDatabase(name: nil, email: self.email)
        }
    }
    
    func performEmailSignIn() {
        isSignInUpInProgress = true
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error {
                self.setErrorMessage(for: error)                
                self.isSignInUpInProgress = false
                
                return
            }
            
            Logger.auth.info("Successfully logged into Firebase with User Email")
            self.successfullyLoggedIn = true
        }
    }
}

// MARK: - FirebaseSDK
extension LoginViewModel {
    private func pushUserToDatabase(name: String?, email: String?) {
        firebaseDatabaseManager.pushUserInfoToFirebase(name: name, email: email)
        
        self.successfullyLoggedIn = true
    }
}
