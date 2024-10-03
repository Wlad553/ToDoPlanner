//
//  MainViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 10/09/2024.
//

import SwiftUI

@Observable
final class MainViewModel: TasksViewParentViewModel {
    enum Tab {
        case tasks
        case calendar
        case account
    }
    
    var selectedTab: Tab
    private var syncIsInProgress = false
    
    // MARK: - Init
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
        super.init(isSearchBarPresent: true, selectedDateComponents: DateComponents())
    }
    
    // MARK: - Data sync
    func observeFirebaseToDoTasks() {
        firebaseDatabaseManager.observeToDoTasks {
            self.syncSwiftDataWithFirebaseDatabase()
        }
    }
    
    private func syncSwiftDataWithFirebaseDatabase() {
        // Avoid triggering a new sync if one is already in progress
        guard syncIsInProgress == false else { return }
        syncIsInProgress = true
        
        Task {
            // Ensure that the sync is properly finalized, regardless of what happens
            defer {
                refreshToDoTasks(animated: true)
                syncIsInProgress = false
            }
            
            let databaseToDoTasksLastUpdateTime = await firebaseDatabaseManager.pullLastUpdatedTimestamp() ?? 0
            
            guard let localToDoTasksLastUpdateTime = UserDefaults.standard.object(forKey: "toDoTasksLastUpdateTime") as? TimeInterval
            else {
                // If no local timestamp exists, fetch all tasks from Firebase and save them locally
                let remoteToDoTasks = await firebaseDatabaseManager.pullToDoTasks() ?? []
                remoteToDoTasks.forEach { toDoTask in
                    swiftDataManager.save(toDoTask: toDoTask)
                }
                
                UserDefaults.standard.set(databaseToDoTasksLastUpdateTime, forKey: "toDoTasksLastUpdateTime")
                
                return
            }
            
            // If timestamps are equal or tasks cannot be retrieved, exit sync
            guard databaseToDoTasksLastUpdateTime != localToDoTasksLastUpdateTime,
                  let swiftDataToDoTasks = swiftDataManager.toDoTasks,
                  let databaseToDoTasks = await firebaseDatabaseManager.pullToDoTasks()
            else { return }
            
            // Iterate through each local task and compare it to its Firebase counterpart
            for localTask in swiftDataToDoTasks {
                // Check if the local task exists in Firebase
                if let matchingFirebaseTask = databaseToDoTasks.first(where: { $0.id == localTask.id }) {
                    
                    // Compare lastUpdated timestamps
                    if localTask.lastUpdateTimestamp > matchingFirebaseTask.lastUpdateTimestamp {
                        // If local task is more recent, push it to Firebase
                        firebaseDatabaseManager.pushToDoTaskToFirebase(toDoTask: localTask, updateLastUpdatedTimestamp: false)
                    } else if matchingFirebaseTask.lastUpdateTimestamp > localTask.lastUpdateTimestamp {
                        // If Firebase task is more recent, update the local task
                        swiftDataManager.applyChangesFor(toDoTask: localTask, draftToDoTask: matchingFirebaseTask)
                    }
                } else {
                    // If Firebase doesn't have this task, then:
                    if databaseToDoTasksLastUpdateTime > localTask.lastUpdateTimestamp {
                        // If Firebase's global update time is more recent, delete the local task
                        swiftDataManager.delete(toDoTask: localTask)
                    } else {
                        // Otherwise, push the local task to Firebase
                        firebaseDatabaseManager.pushToDoTaskToFirebase(toDoTask: localTask, updateLastUpdatedTimestamp: false)
                    }
                }
            }
            
            // Check for tasks in Firebase that do not exist locally
            for remoteTask in databaseToDoTasks {
                if swiftDataToDoTasks.first(where: { $0.id == remoteTask.id }) == nil {
                    
                    if localToDoTasksLastUpdateTime > remoteTask.lastUpdateTimestamp {
                        // If local timestamp is more recent, delete the task from Firebase
                        firebaseDatabaseManager.deleteTaskFromFirebase(toDoTask: remoteTask, updateLastUpdatedTimestamp: false)
                    } else {
                        // Otherwise, add the Firebase task to the local database
                        swiftDataManager.save(toDoTask: remoteTask)
                    }
                }
            }
            
            // Update Firebase with the most recent `lastUpdatedTimestamp`
            firebaseDatabaseManager.pushLastUpdatedTimestampToFirebase(updateTime: max(localToDoTasksLastUpdateTime, databaseToDoTasksLastUpdateTime))
        }
    }
}
