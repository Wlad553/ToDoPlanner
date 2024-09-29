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
}
