//
//  NotificationViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/28/23.
//

import Foundation
import UserNotifications

class NotificationViewModel: ObservableObject{
    private var notificationDictionary: [Int: [String]] = [:]
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permissions granted")
            } else if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    func scheduleDailyNotification(medicineName: String, time: Date, notificationID: String ) {
           let content = UNMutableNotificationContent()
        let hour: Int = Int(HelperFunction().formattedHour(time))!
        let min: Int = Int(HelperFunction().formattedMinutes(time))!
           content.title = "It's time to take your \(hour):\(min) meds!"
           content.body = "Don't forget to take '\(medicineName)' and mark as taken"
           content.sound = UNNotificationSound.default

           var dateComponents = DateComponents()
           dateComponents.hour = hour
           dateComponents.minute = min

           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

           let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Error scheduling notification: \(error)")
               }
           }
       }
    
    func cancelNotifications(notificationID: String) {
        let notificationIdentifier = notificationID

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
     }
}
