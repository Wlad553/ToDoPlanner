//
//  ToDoPlannerApp.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI
import SwiftData

@main
struct ToDoPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(selectedTab: .tasks)
        }
        .modelContainer(for: ToDoTask.self)
    }
}
