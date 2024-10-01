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
    
    func saveUserIntoDatabase(name: String?, email: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["name": name, "email": email]
        let values = [uid: userData]
        
        FirebaseDatabaseManager.databaseReference.child("users").updateChildValues(values)
    }
    
    // MARK: - Firebase Data Manipulation
    func saveTaskIntoDatabase(toDoTask: ToDoTask) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let toDoTaskData = toDoTask.toDictionary()
        
        FirebaseDatabaseManager.databaseReference
            .child("tasks")
            .child(uid)
            .child(toDoTask.id.uuidString)
            .setValue(toDoTaskData)
    }
    
    func deleteTaskFromDatabase(toDoTask: ToDoTask) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseDatabaseManager.databaseReference
            .child("tasks")
            .child(uid)
            .child(toDoTask.id.uuidString)
            .removeValue()
    }
    
    func updateTaskInDatabase(toDoTask: ToDoTask, draftToDoTask: ToDoTask? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var toDoTaskData : [String: Any]
        
        if let draftToDoTask {
            toDoTaskData = draftToDoTask.toDictionary()
            toDoTaskData["id"] = toDoTask.id.uuidString
        } else {
            toDoTaskData = toDoTask.toDictionary()
        }
        
        FirebaseDatabaseManager.databaseReference
            .child("tasks")
            .child(uid)
            .child(toDoTask.id.uuidString)
            .setValue(toDoTaskData)
    }
}
