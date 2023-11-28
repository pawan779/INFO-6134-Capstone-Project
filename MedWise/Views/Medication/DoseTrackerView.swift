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
                    
                    HStack {
                        Text("Number of tablets in a dose:")
                              .font(.headline) 
                              .foregroundColor(.white)
                              .lineLimit(1)
                              .minimumScaleFactor(0.5)
                            
                              .padding(.trailing, 5)

                       
                          Text("\(viewModel.numberOfTablets)")
                              
                              .font(.title3)
                              .foregroundColor(.white)
                              .frame(width: 36, alignment: .leading)
                              .padding(.leading, 0)
                   
                        Button(action: {
                            if viewModel.numberOfTablets > 0 { viewModel.numberOfTablets -= 1 }
                        }) {
                            Image(systemName: "minus")
                                .padding(5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(width: 34, height: 34)
                        .foregroundColor(.white)
                        .background(Color.customBackgroundColor)
                        .cornerRadius(8)
                        Divider()
                            .frame(height: 34)
                            .background(Color.white.opacity(0.5))

                        Button(action: {
                            if viewModel.numberOfTablets < 100 { viewModel.numberOfTablets += 1 }
                        }) {
                            Image(systemName: "plus")
                                .padding(5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(width: 34, height: 34)
                        .foregroundColor(.white)
                        .background(Color.customBackgroundColor)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)

                    
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
