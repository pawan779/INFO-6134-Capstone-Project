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

           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats:false)

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
    
     func notificationScheduler(for appointment: Appointment) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Doctor's Appointment"
        content.subtitle = "With \(appointment.doctorName)"
        content.body = "Don't forget your appointment for \(appointment.reason) on \(HelperFunction().formattedTime(appointment.date))"
        content.sound = UNNotificationSound.default
         
         // Print information for debugging
            print("Scheduling Notification for Appointment:")
            print("Doctor Name: \(appointment.doctorName)")
            print("Reason: \(appointment.reason)")
            print("Date: \(appointment.date)")
            print("Formatted Time: \(HelperFunction().formattedTime(appointment.date))")
         
         let today = Calendar.current.startOfDay(for: Date())
         
         if today == Calendar.current.startOfDay(for: appointment.date) {
             var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: appointment.date)
                 dateComponents.hour = 6
                 dateComponents.minute = 0
             
             // Print date components for debugging
                     print("Notification Date Components: \(dateComponents)")
             
             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
             
             let identifier = appointment.id.uuidString

             let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
             
             //Before scheduling the notification
             print("Scheduling Notification Request:")
             print("Identifier: \(identifier)")
             print("Trigger: \(trigger)")
             
             UNUserNotificationCenter.current().add(request) { error in
                 if let error = error {
                     print("Error scheduling notification: \(error.localizedDescription)")
                 } else {
                     print("notification success")
                 }
             }
         } else {
             print("Appointment is not today. No notification scheduled...")
         }
    }
    
    func stopNotification(for appointment: Appointment) {
        let identifier = appointment.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        print("Notification canceled for appointment with ID: \(appointment.id)")
    }
}
