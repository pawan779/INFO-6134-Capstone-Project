//
//  Appointment.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import Foundation

struct Appointment: Identifiable {
    var id: UUID
    var doctorName: String
    var reason: String
    var contactNumber: String
    var date: Date
    var time: Date
}
