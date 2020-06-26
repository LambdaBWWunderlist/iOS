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
    
    let userNotificationCenter = UNUserNotificationCenter.current()
//    let dailyTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
    let calendar = Calendar.current
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
    
//    func triggerNotification(todo: Todo, notificationType: NotificationType, onDate date: Date, withId id: String) {
//        self.date = date
//        let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
//        let identifier = id
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: scheduleNotification(todo: todo, notificationType: notificationType),
//                                            trigger: trigger)
//        userNotificationCenter.add(request) { (error) in
//            print("notification: \(request.identifier)")
//            if let error = error {
//                print("Error \(error.localizedDescription)")
//            }
//        }
//    }
    
    func triggerNotification(todoRep: TodoRepresentation, notificationType: NotificationType, onDate date: Date) {
        switch notificationType {
        case .reminderOneTime:
            self.date = date
            let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
            let identifier = todoRep.identifier
            let request = UNNotificationRequest(identifier: String(identifier ?? 404),
                                                content: scheduleNotification(todoRep: todoRep, notificationType: .reminderOneTime),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .reminderDaily:
            self.date = date
            let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = todoRep.identifier
            let request = UNNotificationRequest(identifier: String(identifier ?? 404),
                                                content: scheduleNotification(todoRep: todoRep, notificationType: .reminderDaily),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .reminderWeekly:
            self.date = date
            let notificationDate = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = todoRep.identifier
            let request = UNNotificationRequest(identifier: String(identifier ?? 404),
                                                content: scheduleNotification(todoRep: todoRep, notificationType: .reminderWeekly),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .reminderMonthly:
            self.date = date
            var monthlyComponents = DateComponents()
            let notificationDate = Calendar.current.dateComponents([.weekdayOrdinal,.hour,.minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = todoRep.identifier
            let request = UNNotificationRequest(identifier: String(identifier ?? 404),
                                                content: scheduleNotification(todoRep: todoRep, notificationType: .reminderMonthly),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func scheduleNotification(todoRep: TodoRepresentation, notificationType: NotificationType) -> UNMutableNotificationContent {
        print("Scheduling")
        let content = UNMutableNotificationContent()
        content.sound = .default
        switch notificationType {
        case .reminderDaily:
            content.title = "\(todoRep.name)"
            content.body = "This is your daily reminder.\n\(todoRep.body)"
        case .reminderWeekly:
            content.title = "\(todoRep.name)"
            content.body = "This is your weekly reminder.\n\(todoRep.body)"
        case .reminderOneTime:
            content.title = "\(todoRep.name)"
            content.body = "\(todoRep.body)"
        case .reminderMonthly:
            content.title = "\(todoRep.name)"
            content.body = "This is your monthly reminder.\n\(todoRep.body)"
        }
        //content.badge = 1 (can't figure out how to clear this)
        return content
    }
}
