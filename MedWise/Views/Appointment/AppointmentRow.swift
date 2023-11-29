//
//  AppointmentRow.swift
//  MedWise
//
//  Created by Anup Saud on 2023-11-07.
//

import SwiftUI

struct AppointmentRow: View {
    var appointment: Appointment
    @ObservedObject var viewModel: AppointmentViewModel
    @ObservedObject var viewNotification: NotificationViewModel
    @State private var isShowingOptionsAlert = false
    
    let helper = HelperFunction()
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "stethoscope")
                    .foregroundColor(.blue)
                    .font(.title)
                Text(appointment.doctorName)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Text("Reason: \(appointment.reason)")
                .foregroundColor(.black)
            Text("Contact: \(appointment.contactNumber)")
                .foregroundColor(.black)
            Text("Date: \(appointment.date, style: .date)")
                .foregroundColor(.black)
            Text("Time: \(appointment.time, style: .time)")
                .foregroundColor(.black)
        }
        .padding([.top, .bottom], 20)
         .padding([.leading, .trailing], 20)
         .frame(maxWidth: .infinity)
         .background(Color.white)
   
         .cornerRadius(10)
         .shadow(color: .gray, radius: 3, x: 0, y: 2)
         .padding(.horizontal, 10)
        
        .onTapGesture {
            isShowingOptionsAlert = true
        }
        
        .alert(isPresented: $isShowingOptionsAlert) {
            Alert(
                title: Text("Are you sure you want to delete this appointment?"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewNotification.stopNotification(for: appointment)
                    viewModel.deleteAppointment(appointmentID: appointment.id)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
}
