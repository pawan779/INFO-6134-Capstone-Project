//
//  AddAppointmentView.swift
//  MedWise
//
//  Created by Anup Saud on 2023-11-06.
//

import SwiftUI

struct AddAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AppointmentViewModel // Assume this is defined somewhere
    @ObservedObject var viewNotification: NotificationViewModel
    
    @State private var doctorName: String = ""
    @State private var reason: String = ""
    @State private var contactNumber: String = ""
    @State private var date: Date = Date()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isDoctorNameValid: Bool = true
    @State private var isReasonValid: Bool = true
    @State private var isContactNumberValid: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.customBackgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 15) {
                        Spacer().frame(height: 20)
                        
                        Text("Appointment Details")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.vertical)
                        
                        TextField("Doctor's Name", text: $doctorName)
                            .foregroundColor(.black)
                            .onChange(of: doctorName) {
                                isDoctorNameValid = !doctorName.isEmpty
                            }
                        
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        if !isDoctorNameValid {
                            Text("Doctor's name is required.")
                                .foregroundColor(.red)
                        }

                        TextField("Reason for Appointment", text: $reason)
                            .foregroundColor(.black)
                            .onChange(of: reason) {
                                isReasonValid = !reason.isEmpty // Validate the reason
                            }
                            
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        if !isReasonValid {
                            Text("Reason for appointment is required.")
                                .foregroundColor(.red)
                        }
                        TextField("Contact Number", text: $contactNumber)
                            .foregroundColor(.black)
                            .keyboardType(.numberPad)
                            .onChange(of: contactNumber) {
                                validateContactNumber()
                            }

                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)



                        if !isContactNumberValid {
                            Text("Valid contact number is required.")
                                .foregroundColor(.red)
                        }

                        
                        DatePicker("Select Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        
                        // Confirm Button
                        Button(action: confirmAppointment) {
                            Text("Confirm")
                                .foregroundColor(.white)
                                .frame(width: 100)
                                
                                .padding()
                                .background(isDoctorNameValid && isReasonValid && isContactNumberValid ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(!(isDoctorNameValid && isReasonValid && isContactNumberValid))
                        .padding()
                        
                        Spacer().frame(height: 20)
                    }
                 
                
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer()
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.white)
                        Text("Appointment")
                            .foregroundColor(.white)
                            .font(.title)
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Missing Information"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

        }
    }
     
    // MARK: - Validation Functions
    
    private func validateDoctorName() {
        isDoctorNameValid = !doctorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func validateReason() {
        isReasonValid = !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func validateContactNumber() {
        // Check for an optional plus sign followed by 9 to 14 digits (most country codes plus phone numbers will fall within this range)
        let phoneRegex = "^(\\+)?[0-9]{9,14}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        isContactNumberValid = phonePredicate.evaluate(with: contactNumber)
    }
    
    private func isAllInputValid() -> Bool {
        return isDoctorNameValid && isReasonValid && isContactNumberValid
    }
    
    private func confirmAppointment() {
        // Trim whitespace and newlines from input fields
        let trimmedDoctorName = doctorName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContactNumber = contactNumber.trimmingCharacters(in: .whitespacesAndNewlines)

        // Validate trimmed values again before attempting to create an appointment
        isDoctorNameValid = !trimmedDoctorName.isEmpty
        isReasonValid = !trimmedReason.isEmpty
        isContactNumberValid = trimmedContactNumber.count >= 10 && trimmedContactNumber.count <= 15
        
        // Check if all inputs are valid after trimming
        if !isAllInputValid() {
            // Prepare the alert message depending on which fields are invalid
            var errorMessage = ""
            if !isDoctorNameValid {
                errorMessage += "Doctor's name is required.\n"
            }
            if !isReasonValid {
                errorMessage += "Reason for appointment is required.\n"
            }
            if !isContactNumberValid {
                errorMessage += "Valid contact number is required.\n"
            }
            
            // Set the alert message and show alert
            alertMessage = errorMessage
            showAlert = true
            return
        }
        
        // Proceed with creating the appointment
        let newAppointment = Appointment(id: UUID(), doctorName: trimmedDoctorName, reason: trimmedReason, contactNumber: trimmedContactNumber, date: date, time: date)
        viewModel.addAppointment(newAppointment)
        
        // Schedule a local notification
        viewNotification.notificationScheduler(for: newAppointment)
        
        
        // Dismiss the current view
        presentationMode.wrappedValue.dismiss()
    }

    
    struct AddAppointmentView_Previews: PreviewProvider {
        static var previews: some View {
            AddAppointmentView(viewModel: AppointmentViewModel(), viewNotification: NotificationViewModel())
        }
    }
}
    
    struct FloatingActionButton: View {
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .background(Color.customBackgroundColor)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
            .shadow(radius: 2)
        }
    }
    

