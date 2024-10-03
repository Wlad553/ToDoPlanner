//
//  UserNotificationsManager.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 03/10/2024.
//

import UserNotifications
import OSLog

struct UserNotificationsManager {
    func scheduleNotification(for toDoTask: ToDoTask) {
        // Ensure the due date is in the future
        guard toDoTask.dueDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(toDoTask.title) is Due!"
        content.body = "Your \(toDoTask.priority.name) priority task from the \(toDoTask.category.name) category is due now."
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: toDoTask.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: toDoTask.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                Logger.userNotifications.error("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(for toDoTask: ToDoTask) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [toDoTask.id.uuidString])
    }
}
