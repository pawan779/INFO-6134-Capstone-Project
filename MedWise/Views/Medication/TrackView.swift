//
//  TrackView.swift
//  MedWise
//
//  Created by Anup Saud on 2023-10-25.
//

import SwiftUI

struct TrackView: View {
    
    @ObservedObject var viewModel: MedicationListViewModel
    
    var body: some View {

            GeometryReader { geometry in
                VStack(spacing: 30) {
                    Text("Do you want to track your medicine?")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                
                    
                    VStack(spacing: 20) {
                        
                        NavigationLink(
                            destination: DoseTrackerView(viewModel: viewModel),
                            label: {
                                Text("Yes")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 50)
                                    .padding(.vertical, 15)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            })
                        
                        Button(action: {
                           addMedicine()
                        }, label: {
                            Text("No")
                                .foregroundColor(.white)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 15)
                                .background(Color.gray)
                                .cornerRadius(8)
                        })
                        
                    }
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.customBackgroundColor)
              
            }
        }
    
func addMedicine(){
    
            if(viewModel.isEditMode){
    
                viewModel.dataToBeUpdate[viewModel.selectedIndex].time = viewModel.selectedTimes[0]

                viewModel.updateMedication(medicineName: viewModel.medicineName, reminderTime:viewModel.dataToBeUpdate, id: viewModel.selectedMedicationId,  isDosedTracking: false, numberOfTablets: nil, reminderOption: nil, notificationID: viewModel.selectedNotificationID, notificationTime: viewModel.notificationTime )
                
                viewModel.toggleAddMedication()
                viewModel.medicineName = ""
    
    
                viewModel.clear()
            }
            else{
    viewModel.addMedication(medicineName: viewModel.medicineName, reminderTime: viewModel.selectedTimes, isDosedTracking: false, numberOfTablets: nil, reminderOption: nil )
    viewModel.toggleAddMedication()
                
                viewModel.clear()
            }
}
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(viewModel: MedicationListViewModel())
    }
}
