//
//  History.swift
//  MedWise
//
//  Created by Pawan Dharel on 11/26/23.
//

import Foundation

struct History: Identifiable {
    var id: UUID
    var medicineId: Int
    var reminderTimeId: Int
    var medicineName: String
    var takenDate: Date
    var isTaken: Bool
    
    init(id: UUID = UUID(), medicineId: Int, reminderTimeId: Int, medicineName: String, takenDate: Date, isTaken: Bool) {
        self.id = id
        self.medicineId = medicineId
        self.reminderTimeId = reminderTimeId
        self.medicineName = medicineName
        self.takenDate = takenDate
        self.isTaken = isTaken
    }
}


