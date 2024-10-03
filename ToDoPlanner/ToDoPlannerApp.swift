//
//  ToDoPlannerApp.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI
import SwiftData
import FBSDKCoreKit
import GoogleSignIn
import FirebaseCore

@main
struct ToDoPlannerApp: App {
    @State var appState = AppState()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .opacity(appState.appHasBeenLaunched && !appState.welcomeViewIsPresented ? 1 : 0)
                .environment(appState)
                .onAppear {
                    if !FirebaseApp.isDefaultAppConfigured() {
                        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                        FirebaseApp.configure()
                    }
                }
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                    ApplicationDelegate.shared.application(UIApplication.shared,
                                                           open: url,
                                                           sourceApplication: nil,
                                                           annotation: [UIApplication.OpenURLOptionsKey.annotation])
                }
                .fullScreenCover(isPresented: $appState.welcomeViewIsPresented, content: {
                    WelcomeView()
                        .environment(appState)
                })
        } // -- WindowGroup
        .modelContainer(ToDoTaskModelContainer.shared.container)
        .onChange(of: scenePhase) { _, newScenePhase in
            if newScenePhase == .active  {
                appState.checkAuthenticationStatus()
            }
        }
    }
}
