//
//  ToDoPlannerApp.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI
import SwiftData
import FBSDKCoreKit

@main
struct ToDoPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .onOpenURL { url in
                    ApplicationDelegate.shared.application(UIApplication.shared,
                                                           open: url,
                                                           sourceApplication: nil,
                                                           annotation: [UIApplication.OpenURLOptionsKey.annotation])
                }
        }
        .modelContainer(ToDoTaskModelContainer.shared.container)
    }
}
