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
    let databaseManager = FirebaseDatabaseManager()
    
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
        
        print(error.localizedDescription)
        print(error.code)
        
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
                print("Logged In with FB")
                self.signIntoFirebaseWithFacebook(nonce: nonce)
                
            case .failed(let error):
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
                print("Firebase FB user authorisation error: \(error.localizedDescription)")
                self.setErrorMessage(for: error)
                
                return
            }
            
            print("Firebase FB user log in succeeded: \(String(describing: user))")
            self.fetchFacebookFields()
        }
    }
    
    private func fetchFacebookFields() {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"]).start { _, result, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            if let userData = result {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
                let fbUserProfile = try? JSONDecoder().decode(FBUserProfile.self, from: jsonData)
                
                self.saveUserIntoDatabase(name: fbUserProfile?.name, email: fbUserProfile?.email)
            }
        }
    }
}

// MARK: - Google Sign In Flow
extension LoginViewModel {
    func performGoogleSignIn(withPresenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] result, error in
            if let error {
                print("Failed to log in with Google: \(error.localizedDescription)")
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
                    print("Failed to log into Firebase with Google: \(error.localizedDescription)")
                    self.setErrorMessage(for: error)

                    return
                }
                
                self.saveUserIntoDatabase(name: result?.user.profile?.name, email: result?.user.profile?.email)
                print("Successfully loged in using Google")
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
            
            print("Successfully logged into Firebase with User Email")
            self.saveUserIntoDatabase(name: nil, email: self.email)
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
            
            print("Successfully logged in")
            self.successfullyLoggedIn = true
        }
    }
}

// MARK: - FirebaseSDK
extension LoginViewModel {
    private func saveUserIntoDatabase(name: String?, email: String?) {
        databaseManager.saveUserIntoDatabase(name: name, email: email)
        
        self.successfullyLoggedIn = true
    }
}
