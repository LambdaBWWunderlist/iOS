//
//  NotificationController.swift
//  Wunderlist
//
//  Created by Thomas Sabino-Benowitz on 6/25/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    
    var components = DateComponents()
    components.hour = 10
    components.minute = 30
    var dailyComponents = DateComponents
    dailyComponents.day = 1
    let userNotificationCenter = UNUserNotificationCenter.current()
    let dailyTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private var date = Date()
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func triggerNotification(todo: Todo, notificationType: NotificationType, onDate date: Date, withId id: String) {
        self.date = date
        let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
        let identifier = id
        let request = UNNotificationRequest(identifier: identifier,
                                            content: scheduleNotification(todo: todo, notificationType: notificationType),
                                            trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            print("notification: \(request.identifier)")
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func triggerNotification(todo: Todo, notificationType: NotificationType, onDate date: Date, withId id: String) {
        switch NotificationType {
        case .reminderOneTime:
            self.date = date
            let notificationDate = date(from: components)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(todo: todo, notificationType: notificationType),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .reminderDaily:
            self.date = date
            let notificationDate = date
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(todo: todo, notificationType: notificationType),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .reminderWeekly:
            self.date = date
            let notificationDate = date.Calendar.dateComponents.weekly
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(todo: todo, notificationType: notificationType),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .reminderMonthly:
            self.date = date
            let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(todo: todo, notificationType: notificationType),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func scheduleNotification(todo: Todo, notificationType: NotificationType) -> UNMutableNotificationContent {
        print("Scheduling")
        let content = UNMutableNotificationContent()
        content.sound = .default
        switch notificationType {
        case .reminderDaily:
            content.title = "\(todo.name)"
            content.body = "This is your daily reminder.\n\(todo.body)"
        case .reminderWeekly:
            content.title = "\(todo.name)"
            content.body = "This is your weekly reminder.\n\(todo.body)"
        case .reminderOneTime:
            content.title = "\(todo.name)"
            content.body = "\(todo.body)"
        case .reminderMonthly:
            content.title = "\(todo.name)"
            content.body = "This is your monthly reminder.\n\(todo.body)"
        }
        //content.badge = 1 (can't figure out how to clear this)
        return content
    }
}
