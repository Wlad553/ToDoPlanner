//
//  Logger+categories.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 03/10/2024.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let swiftData = Logger(subsystem: subsystem, category: "swiftData")
    static let firebase = Logger(subsystem: subsystem, category: "firebase")
    static let auth = Logger(subsystem: subsystem, category: "auth")
    static let userNotifications = Logger(subsystem: subsystem, category: "userNotifications")
}

