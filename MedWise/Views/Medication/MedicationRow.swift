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
    var body: some View {
    
            ZStack{
                VStack{
                    ForEach(Array(medicine.reminderTime.enumerated()), id: \.1.id) { (index, reminderTime) in
//                        NavigationLink(destination: AddMedicationView(viewModel:viewModel).onAppear(perform: {
//                            viewModel.medicineName = medicine.medicineName
//                        })) {
//                            TimeerView(time: date, medicineName: medicine.medicineName)
//                        }
                        
//                        Button(action: {   viewModel.toggleAddMedication()
//                            viewModel.medicineName = medicine.medicineName
//                            viewModel.selectedTimes = [reminderTime.time]
//                            viewModel.isEditMode = true
//                            viewModel.dataToBeUpdate = medicine.reminderTime
//                            viewModel.selectedIndex = index
//                            viewModel.selectedMedicationId = medicine.id
//                        }, label: {
                        TimerView(reminderTime: reminderTime, medicine: medicine, viewModel: viewModel)
                            
                            
//                        })
//                        .sheet(isPresented: $viewModel.isPresented) {
//                            AddMedicationView(viewModel:viewModel)
//                        }
                    }
                }
            }
            
        
}


struct TimerView: View{
    
    var reminderTime: ReminderTime
    var medicine: Medication
    var viewModel: MedicationListViewModel
    
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
    MedicationRow(medicine: Medication(id: 1, medicineName: "Medicine A", reminderTime: [ReminderTime(id: 1, time: Date(), isTaken: false)], isDosedTracking: false), viewModel: MedicationListViewModel())}
