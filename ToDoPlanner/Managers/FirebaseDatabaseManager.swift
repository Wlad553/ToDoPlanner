//
//  FirebaseDatabaseManager.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/09/2024.
//

import FirebaseDatabase
import FirebaseAuth
import OSLog

final class FirebaseDatabaseManager {
    static let databaseReference: DatabaseReference = Database.database(url: "https://to-do-planner-17bdb-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    // MARK: - Firebase Data Manipulation
    // MARK: User info
    func pushUserInfoToFirebase(name: String?, email: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData = ["name": name, "email": email]
        let values = [uid: userData]
        
        Self.databaseReference
            .child("users")
            .updateChildValues(values) { error, _ in
                if let error {
                    Logger.firebase.error("Failed to push user info to Firebase: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: LastUpdatedTimestamp
    func pushLastUpdatedTimestampToFirebase(updateTime: TimeInterval = Date().timeIntervalSince1970) {
        UserDefaults.standard.set(updateTime, forKey: "toDoTasksLastUpdateTime")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Self.databaseReference
            .child("tasks")
            .child(uid)
            .child("lastUpdatedTimestamp")
            .setValue(updateTime) { error, _ in
                if let error {
                    Logger.firebase.error("Failed to push last updated timestamp to Firebase: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: ToDoTasks
    func pushToDoTaskToFirebase(toDoTask: ToDoTask, updateLastUpdatedTimestamp: Bool = true) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let toDoTaskData = toDoTask.toDictionary()
        
        Self.databaseReference
            .child("tasks")
            .child(uid)
            .child(toDoTask.id.uuidString)
            .setValue(toDoTaskData) { error, _ in
                if let error {
                    Logger.firebase.error("Failed to push toDoTask to Firebase: \(error.localizedDescription)")
                }
            }
        
        if updateLastUpdatedTimestamp {
            pushLastUpdatedTimestampToFirebase()
        }
    }
    
    func deleteTaskFromFirebase(toDoTask: ToDoTask, updateLastUpdatedTimestamp: Bool = true) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Self.databaseReference
            .child("tasks")
            .child(uid)
            .child(toDoTask.id.uuidString)
            .removeValue() { error, _ in
                if let error {
                    Logger.firebase.error("Failed to delete toDoTask from Firebase: \(error.localizedDescription)")
                }
            }
        
        if updateLastUpdatedTimestamp {
            pushLastUpdatedTimestampToFirebase()
        }
    }
    
    // MARK: - Firebase Data Pull
    func pullLastUpdatedTimestamp() async -> TimeInterval? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        return await Self.databaseReference
            .child("tasks")
            .child(uid)
            .child("lastUpdatedTimestamp")
            .observeSingleEventAndPreviousSiblingKey(of: .value).0
            .value as? TimeInterval
    }
    
    func pullToDoTasks() async -> [ToDoTask]? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        var tasks: [ToDoTask] = []
        
        await Self.databaseReference
            .child("tasks")
            .child(uid)
            .observeSingleEventAndPreviousSiblingKey(of: .value).0
            .children
            .forEach { child in
                if let childSnapshot = child as? DataSnapshot,
                   let toDoTaskDict = childSnapshot.value as? [String: Any],
                   let toDoTask = ToDoTask(dict: toDoTaskDict) {
                    tasks.append(toDoTask)
                }
            }
        
        return tasks
    }
    
    // MARK: Firebase Data Observing
    func observeToDoTasks(handler: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Self.databaseReference
            .child("tasks")
            .child(uid)
            .observe(.value) { _ in
                handler()
                
            } withCancel: { error in
                Logger.firebase.error("Error observing toDoTasks: \(error.localizedDescription)")
            }
    }
    
    func removeObservers() {
        Self.databaseReference.removeAllObservers()
    }
}
