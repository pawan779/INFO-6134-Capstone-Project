//
//  Medication.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import Foundation


struct Medication: Identifiable{
    var id: Int
    var medicineName: String
    var reminderTime: [ReminderTime]
    var isDosedTracking: Bool
    var numberOfTablets: Int?
    var reminderOption: String?
    var medicationDate: Date
   
    
    
    
    init(id: Int, medicineName: String, reminderTime: [ReminderTime], isDosedTracking: Bool, numberOfTablets: Int? = nil, reminderOption: String? = nil, medicationDate: Date) {
        self.id = id
        self.medicineName = medicineName
        self.reminderTime = reminderTime
        self.isDosedTracking = isDosedTracking
        self.numberOfTablets = numberOfTablets
        self.reminderOption = reminderOption
        self.medicationDate = medicationDate
    }

}

struct ReminderTime: Identifiable {
    var id: Int
    var time: Date
    var isTaken: Bool
    var notificationID: String
    var takenDate: Date?
    var isSkipped: Bool?

    init(id: Int, time: Date, isTaken: Bool, notificationID: String, takenDate: Date? = nil, isSkipped: Bool? = false ) {
        self.id = id
        self.time = time
        self.isTaken = isTaken
        self.notificationID = notificationID
        self.takenDate = takenDate
        self.isSkipped = isSkipped
    }
}
