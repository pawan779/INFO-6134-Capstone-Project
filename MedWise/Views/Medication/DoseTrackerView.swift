//
//  DoseTrackerView.swift
//  MedWise
//
//  Created by Anup Saud on 2023-10-25.
//

import SwiftUI

struct DoseTrackerView: View {
    
    @ObservedObject var viewModel: MedicationListViewModel
    


    
    var body: some View {
     
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Dose Tracker")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                    
                    Stepper("Number of tablets in a dose: \(viewModel.numberOfTablets)", value: $viewModel.numberOfTablets, in: 0...100)
                        .foregroundColor(.white)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select reminder option")
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.reminderOptions.indices, id: \.self) { index in
                            Button(action: {
                                viewModel.reminderOption = viewModel.reminderOptions[index]
                            }) {
                                HStack {
                                    if viewModel.reminderOption == viewModel.reminderOptions[index] {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray)
                                    }
                                    Text(viewModel.reminderOptions[index])
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 5)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    
                    Button(action: {
                        addMedicine()
                    }, label: {
                        Text("Set Reminder")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.customBackgroundColor)
            }
        }
    
    func addMedicine(){
        
        if(viewModel.isEditMode){

            viewModel.dataToBeUpdate[viewModel.selectedIndex].time = viewModel.selectedTimes[0]

            viewModel.updateMedication(medicineName: viewModel.medicineName, reminderTime:viewModel.dataToBeUpdate, id: viewModel.selectedMedicationId,  isDosedTracking: true, numberOfTablets: viewModel.numberOfTablets, reminderOption: viewModel.reminderOption, notificationID: viewModel.selectedNotificationID, notificationTime: viewModel.notificationTime )
            
            viewModel.toggleAddMedication()
            viewModel.medicineName = ""
            
            viewModel.clear()

        }
        else{
            
            viewModel.addMedication(medicineName: viewModel.medicineName, reminderTime: viewModel.selectedTimes, isDosedTracking: true, numberOfTablets: viewModel.numberOfTablets, reminderOption: viewModel.reminderOption )
            
            viewModel.toggleAddMedication()
            viewModel.medicineName = ""
            viewModel.clear()
        }
    }
    
    
}

struct DoseTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        DoseTrackerView(viewModel: MedicationListViewModel())
    }
}
