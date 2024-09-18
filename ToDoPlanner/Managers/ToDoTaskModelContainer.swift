//
//  ToDoTaskModelContainer.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 18/09/2024.
//

import SwiftData
import Foundation

struct ToDoTaskModelContainer {
    static let shared = ToDoTaskModelContainer()
    
    let container: ModelContainer

    private init() {
        let schema = Schema([ToDoTask.self])
        let configuration = ModelConfiguration()
        
        do {
            container = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
}
