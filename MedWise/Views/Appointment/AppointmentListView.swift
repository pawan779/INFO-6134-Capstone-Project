//
//  AppointmentListView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct AppointmentListView: View {
    @ObservedObject var viewModel: AppointmentViewModel
    @State private var showAddAppointmentForm = false
    let helper = HelperFunction()
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
//            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            Color.customBackgroundColor
                            .edgesIgnoringSafeArea(.all)

            // Shake Features
            Text("")
                .onShake {
                    print("Device shaken!")
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Healthy Tips of the Day"),
                        message: Text(viewModel.healthTips.randomElement() ?? "No tips available"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            
            
            List {
                ForEach(viewModel.appointments) { appointment in
                    AppointmentRow(appointment: appointment, viewModel: viewModel, viewNotification: NotificationViewModel())
                        .padding(.vertical, 5)
                        .listRowBackground(Color.customBackgroundColor) // Set each list row's background color
                }
                
                .onDelete(perform: deleteAppointments)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Appointments")
            .onAppear(perform: {
                viewModel.fetchAppointments()
            })
//            .environment(\.sizeCategory, .accessibilityMedium)
    

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton(action: {
                        showAddAppointmentForm.toggle()
                    })
//                    .background(Color.customBackgroundColor)
//                    .foregroundColor(.white)
                    .frame(width: 60, height: 100)
                    .padding(.bottom, 60)
                    .padding(.trailing, 20)
                }
            }
        }
        .background(Color.customBackgroundColor)
        .sheet(isPresented: $showAddAppointmentForm) {
            AddAppointmentView(viewModel: viewModel, viewNotification: NotificationViewModel())
        }
    }

    private func deleteAppointments(at offsets: IndexSet) {
        for offset in offsets {
            let id = viewModel.appointments[offset].id
            viewModel.deleteAppointment(appointmentID: id)
        }

        viewModel.fetchAppointments()
    }
}


// Preview for AppointmentListView
struct AppointmentListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentListView(viewModel: AppointmentViewModel())
    }
}
