//
//  FirebaseDatabaseManager.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/09/2024.
//

import FirebaseDatabase
import FirebaseAuth

final class FirebaseDatabaseManager {
    static let databaseReference: DatabaseReference = Database.database(url: "https://to-do-planner-17bdb-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    // MARK: - Firebase Data Manipulation
    func pushUserInfoToFirebase(name: String?, email: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData = ["name": name, "email": email]
        let values = [uid: userData]
        
        Self.databaseReference
            .child("users")
            .updateChildValues(values)
    }
    
    func pushLastUpdatedTimestampToFirebase(updateTime: TimeInterval = Date().timeIntervalSince1970) {        
        UserDefaults.standard.set(updateTime, forKey: "toDoTasksLastUpdateTime")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Self.databaseReference
            .child("tasks")
            .child(uid)
            .child("lastUpdatedTimestamp")
            .setValue(updateTime)
    }
    
    func pushToDoTaskToFirebase(toDoTask: ToDoTask, updateLastUpdatedTimestamp: Bool = true) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let toDoTaskData = toDoTask.toDictionary()
        
        Self.databaseReference
            .child("tasks")
            .child(uid)
            .child(toDoTask.id.uuidString)
            .setValue(toDoTaskData)
        
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
            .removeValue()
        
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
            }
    }
    
    func removeObservers() {
        Self.databaseReference.removeAllObservers()
    }
}
