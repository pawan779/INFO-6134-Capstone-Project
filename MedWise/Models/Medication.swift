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
    var reminderTime: [Date]

}

struct ReminderTime {
    var time: Date
    var isTaken: Bool

    init(time: Date, isTaken: Bool = false) {
        self.time = time
        self.isTaken = isTaken
    }
}
