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
    
    
    init(id: Int, medicineName: String, reminderTime: [ReminderTime], isDosedTracking: Bool, numberOfTablets: Int? = nil, reminderOption: String? = nil) {
        self.id = id
        self.medicineName = medicineName
        self.reminderTime = reminderTime
        self.isDosedTracking = isDosedTracking
        self.numberOfTablets = numberOfTablets
        self.reminderOption = reminderOption
    }

}

struct ReminderTime: Identifiable {
    var id: Int
    var time: Date
    var isTaken: Bool

}
