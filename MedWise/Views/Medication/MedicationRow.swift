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
    var body: some View {
    
   
            ZStack{
                VStack{
                    ForEach(Array(medicine.reminderTime.enumerated()), id: \.1.id) { (index, reminderTime) in
                        TimerView(reminderTime: reminderTime, medicine: medicine, viewModel: viewModel,isShowingOptionsAlert: $isShowingOptionsAlert)
                            
                            .alert(isPresented: $isShowingOptionsAlert) {
                                        Alert(
                                            title: Text("Options for \(medicine.medicineName)"),
                                            message: Text("Choose an option:"),
                                            primaryButton: .default(Text("Edit")) {
                                                viewModel.toggleAddMedication()
                                                 viewModel.medicineName = medicine.medicineName
                                                 viewModel.selectedTimes = [reminderTime.time]
                                                 viewModel.isEditMode = true
                                                 viewModel.dataToBeUpdate = medicine.reminderTime
                                                viewModel.selectedNotificationID = reminderTime.notificationID
                                                viewModel.notificationTime = reminderTime.time
                                                 viewModel.selectedIndex = index
                                                 viewModel.selectedMedicationId = medicine.id
                                                viewModel.reminderOption = medicine.reminderOption ?? "1 week before medicine runs out"
                                                viewModel.numberOfTablets = medicine.numberOfTablets ?? 0


                                            },
                                            secondaryButton: .destructive(Text("Delete")) {
        
                                                viewModel.deleteMedication(mainId: medicine.id, reminderTimeId: reminderTime.id, notificationID: reminderTime.notificationID)
                                            }
                                            
                                            
                                        )
                                    }
                    }
                }
            }
            
        
}


struct TimerView: View{
    
    var reminderTime: ReminderTime
    var medicine: Medication
    var viewModel: MedicationListViewModel
    @Binding var isShowingOptionsAlert: Bool
    
    var body: some View {
        VStack(spacing:0){
            
            ZStack(){
                Color.listViewColor
                VStack{
                    HStack(){
                        Image(systemName: "clock")
                           
                        Text("\(HelperFunction().formattedTime(reminderTime.time))")
                           
                        Spacer()
                       
                        if(medicine.isDosedTracking){
                            Image(systemName: "pills.fill")
                            
                            Text("\(medicine.numberOfTablets ?? 0 >= 0 ? medicine.numberOfTablets! : 0)")
                        }
                        
                    } .font(.headline)
                        .foregroundColor(.gray)
                      
                    
                    
                    Text("\(medicine.medicineName)")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                    
                }
                .padding()
               
                
            }.frame(height: 90)
                .onTapGesture {
                    isShowingOptionsAlert = true
                }
               
            ZStack(){
                Color.white
                
                Text("\(reminderTime.isTaken ? "Taken" : "Take")")
                    .font(.title3)
                    .foregroundColor(.customBackgroundColor)
                    .fontWeight(.bold)
              
            }.frame(height: 50)
            .onTapGesture {
                if !reminderTime.isTaken {
                    viewModel.updateIsTaken(id: medicine.id, reminderTimeID: reminderTime.id, newIsTaken: true)
                }
            }
           

         
        }
        .cornerRadius(10.0)
        .padding()
    }
    }
    
}

#Preview {
    MedicationRow(medicine: Medication(id: 1, medicineName: "Medicine A", reminderTime: [ReminderTime(id: 1, time: Date(), isTaken: false, notificationID: "nil")], isDosedTracking: false, medicationDate: Date()), viewModel: MedicationListViewModel())}


