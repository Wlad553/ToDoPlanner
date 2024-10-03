//
//  AppState.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/09/2024.
//

import SwiftUI
import FirebaseAuth
import UserNotifications
import OSLog

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
    
    func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                Logger.userNotifications.info("Notification permission granted")
            } else if let error {
                Logger.userNotifications.error("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}
