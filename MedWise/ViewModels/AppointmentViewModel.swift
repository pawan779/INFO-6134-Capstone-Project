//
//  AppointmentViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//


import Foundation

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    
    private var databaseHelper = DatabaseHelper.shared
    
    init() {
        fetchAppointments()
    }
    
    func fetchAppointments() {
        appointments = databaseHelper.fetchAppointments()
    }
    
    
    func addAppointment(_ appointment: Appointment) {
        databaseHelper.addAppointment(appointment: appointment)
        fetchAppointments()
    }
    
    func deleteAppointment(appointmentID: UUID) {
        databaseHelper.deleteAppointment(appointmentId: appointmentID)

        fetchAppointments()
    }
}
