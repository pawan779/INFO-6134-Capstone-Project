//
//  MedicationRow.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/23/23.
//

import SwiftUI

struct MedicationRow: View {
    var medicine: Medication
    @ObservedObject var viewModel: MedicationListViewModel
    @State private var isShowingOptionsAlert = false
    @State private var isShowingSkipAlert = false

    var body: some View {
        ZStack {
            VStack {
                ForEach(Array(medicine.reminderTime.enumerated()), id: \.1.id) { (index, reminderTime) in
                    TimerView(
                        reminderTime: reminderTime,
                        medicine: medicine,
                        viewModel: viewModel,
                        isShowingOptionsAlert: $isShowingOptionsAlert
                    )
                }
            }
        }
        .actionSheet(isPresented: $isShowingOptionsAlert) {
                   ActionSheet(
                       title: Text("Options for \(medicine.medicineName)"),
                       message: Text("Choose an option:"),
                       buttons: [
                     
                           .default(Text("Edit")) {
                               viewModel.toggleAddMedication()
                               viewModel.medicineName = medicine.medicineName
                               viewModel.selectedTimes = [medicine.reminderTime[0].time]
                               viewModel.isEditMode = true
                               viewModel.dataToBeUpdate = medicine.reminderTime
                               viewModel.selectedNotificationID = medicine.reminderTime[0].notificationID
                               viewModel.notificationTime = medicine.reminderTime[0].time
                               viewModel.selectedIndex = 0
                               viewModel.selectedMedicationId = medicine.id
                               viewModel.reminderOption = medicine.reminderOption ?? "1 week before medicine runs out"
                               viewModel.numberOfTablets = medicine.numberOfTablets ?? 0
                           },
                           .destructive(Text("Delete")) {
                               viewModel.deleteMedication(mainId: medicine.id, reminderTimeId: medicine.reminderTime[0].id, notificationID: medicine.reminderTime[0].notificationID)
                           },
                            .cancel()
                       ]
                   )
               }
    }
}

struct TimerView: View {
    var reminderTime: ReminderTime
    var medicine: Medication
    var viewModel: MedicationListViewModel
    @Binding var isShowingOptionsAlert: Bool
    @State private var isShowingSkipActionSheet = false

    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.listViewColor
                VStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(HelperFunction().formattedTime(reminderTime.time))")
                        Spacer()
                        if (medicine.isDosedTracking) {
                            Image(systemName: "pills.fill")
                            Text("\(medicine.numberOfTablets ?? 0 >= 0 ? medicine.numberOfTablets! : 0)")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.gray)
                    
                    Text("\(medicine.medicineName)")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }
                .padding()
            }
            .frame(height: 90)
            .onTapGesture {
                isShowingOptionsAlert = true
            }
            
            HStack {
                if (reminderTime.isTaken) {
                    ZStack {
                        Color.white
                        Text("Taken")
                            .foregroundColor(.customBackgroundColor)
                            .fontWeight(.bold)
                    }
                    .frame(height: 50)
                } else if (reminderTime.isSkipped!) {
                    ZStack {
                        Color.gray
                        Text("Skipped")
                            .foregroundColor(.customBackgroundColor)
                            .fontWeight(.bold)
                    }
                    .frame(height: 50)
                } else {
                    ZStack {
                        Color.white
                        Text("Take")
                            .foregroundColor(.customBackgroundColor)
                            .fontWeight(.bold)
                    }
                    .frame(height: 50)
                    .onTapGesture {
                        viewModel.updateIsTaken(id: medicine.id, reminderTimeID: reminderTime.id, newIsTaken: true)
                    }
                    
                    ZStack {
                        Color.yellow
                        Text("Skip")
                            .foregroundColor(.customBackgroundColor)
                            .fontWeight(.bold)
                    }
                    .frame(height: 50)
                    .onTapGesture {  isShowingSkipActionSheet = true
                        
                                    }
                }
            }
        }
        .cornerRadius(10.0)
        .padding()
        .alert(isPresented: $isShowingSkipActionSheet) {
                    Alert(
                        title: Text("Skip Medication"),
                        message: Text("Are you sure you want to skip this medication?"),
                        primaryButton: .default(Text("Cancel")),
                        secondaryButton: .destructive(Text("Skip")) {
                            viewModel.updateIsTaken(id: medicine.id, reminderTimeID: reminderTime.id, newIsTaken: false)
                        }
                    )
                }
    }
}



#Preview {
    MedicationRow(medicine: Medication(id: 1, medicineName: "Medicine A", reminderTime: [ReminderTime(id: 1, time: Date(), isTaken: false, notificationID: "nil")], isDosedTracking: false, medicationDate: Date()), viewModel: MedicationListViewModel())}


