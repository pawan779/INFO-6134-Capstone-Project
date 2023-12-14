//
//  NotificationListView.swift
//  MedWise
//
//  Created by Rajeev Sharma on 2023-12-13.
//

import SwiftUI
import UserNotifications

struct NotificationListView: View {
    
    // Function to check if notifications are enabled
    func areNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
    
    // Function to open app settings
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.openURL(settingsURL)
    }
    
    @State private var isNotificationEnabled = false
    
    var body: some View {
        List {
            Toggle("Notifications", isOn: $isNotificationEnabled)
                .padding()
                .onChange(of: isNotificationEnabled) { newValue in
                    if newValue {
                        enableNotifications()
                    } else {
                        disableNotifications()
                    }
                }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            // Check if notifications are enabled on view appear
            areNotificationsEnabled { isEnabled in
                isNotificationEnabled = isEnabled
            }
        }
        .toolbar {
            // Add a toolbar item with a label and action
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Settings") {
                    // Open app settings if notifications are not enabled
                    openAppSettings()
                }
                .disabled(isNotificationEnabled)
            }
        }
    }
    
    func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // Handle the user's response to the notification permission request
            if granted {
                print("Notifications permission granted")
            } else {
                print("Notifications permission denied")
            }
        }
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Notifications disabled")
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}
