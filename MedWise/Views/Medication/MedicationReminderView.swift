//
//  MedicationReminderView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/22/23.
//

import SwiftUI

struct MedicationReminderView: View {
  
    var selectedFrequency: String
    var medicineName: String
    @State var viewModel : MedicationListViewModel
    
    var body: some View {
            GeometryReader { geometry in
                VStack{
                    HStack{
                        
                        Image(systemName: "bell.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("When do you want to be notified?")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                    
                    ForEach(viewModel.selectedTimes.indices, id: \.self) { index in
                        DatePicker("Reminder Time (\(index + 1))", selection: $viewModel.selectedTimes[index], displayedComponents: .hourAndMinute)
                           
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
                    
                    Spacer()
                    
                    Button(action: {  viewModel.closeAddMedication()
                        addMedicine()
                    }, label: {
                        Text("Done")
                            .foregroundColor(.white)
                            .font(.headline)
                    })
                    
                }.navigationBarBackButtonHidden(true)
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.customBackgroundColor)
                
            
            }
    }
    func addMedicine(){
        viewModel.addMedication(medicineName: medicineName, reminderTime: viewModel.selectedTimes)
    }
}

#Preview {
    MedicationReminderView( selectedFrequency: "", medicineName: "", viewModel: MedicationListViewModel(selectedFrequency: "Twice a day"))
}
